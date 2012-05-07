Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2EGKGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:06:01 -0400
Received: from 2481.rev.megiteam.pl ([91.227.36.129]:32799 "EHLO
	vk1001.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2EGKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:06:00 -0400
Message-ID: <4FA79E81.4050306@localdomain.pl>
Date: Mon, 07 May 2012 12:05:53 +0200
From: Grzegorz Nosek <root@localdomain.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Proper locking for find_task_by_pid_ns?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

TL;DR: my question is whether this:

read_lock(&tasklist_lock);
rcu_read_lock();
p = find_task_by_pid_ns(pid, &init_pid_ns);
rcu_read_unlock();
read_unlock(&tasklist_lock);

is a valid sequence, or is it deadlockable. My Google-fu says _either_ rcu_read_lock or tasklist_lock is required to traverse the task list[1] but I'm not sure about both at the same time.

The whole story:

I encountered a machine crash with the following output on the console (that's all I got):

http://imgur.com/DzksH

The kernel is 3.2.15 plus Linux-VServer (patch-3.2.11-vs2.3.2.8 [2])

I'm guessing (I admit, I didn't disassemble copy_process) the write lock in question is tasklist_lock (the only clearly visible write_lock_irq() call in this function). So to my untrained eye that would look like some process stuck with tasklist_lock held.

The crash happened while shutting down a vserver, which basically looks like this:

long vs_reboot(unsigned int cmd, void __user *arg)
{
       struct vx_info *vxi = current_vx_info();
       long ret = 0;

       vxdprintk(VXD_CBIT(misc, 5),
               "vs_reboot(%p[#%d],%u)",
               vxi, vxi ? vxi->vx_id : 0, cmd);

       ret = vs_reboot_helper(vxi, cmd, arg);
       if (ret)
               return ret;

       vxi->reboot_cmd = cmd;
       if (vx_info_flags(vxi, VXF_REBOOT_KILL, 0)) {
               switch (cmd) {
               case LINUX_REBOOT_CMD_RESTART:
               case LINUX_REBOOT_CMD_HALT:
               case LINUX_REBOOT_CMD_POWER_OFF:
                       vx_info_kill(vxi, 0, SIGKILL);
                       vx_info_kill(vxi, 1, SIGKILL);
               default:
                       break;
               }
       }
       return 0;
}

/* ... */

int vx_info_kill(struct vx_info *vxi, int pid, int sig)
{
       int retval, count = 0;
       struct task_struct *p;
       struct siginfo *sip = SEND_SIG_PRIV;

       retval = -ESRCH;
       vxdprintk(VXD_CBIT(misc, 4),
               "vx_info_kill(%p[#%d],%d,%d)*",
               vxi, vxi->vx_id, pid, sig);
       read_lock(&tasklist_lock);
       switch (pid) {
       case  0:
       case -1:
               for_each_process(p) {
                       int err = 0;

                       if (vx_task_xid(p) != vxi->vx_id || p->pid <= 1 ||
                               (pid && vxi->vx_initpid == p->pid))
                               continue;

                       err = group_send_sig_info(sig, sip, p);
                       ++count;
                       if (err != -EPERM)
                               retval = err;
               }
               break;
       case 1:
               if (vxi->vx_initpid) {
                       pid = vxi->vx_initpid;
                       /* for now, only SIGINT to private init ... */
                       if (!vx_info_flags(vxi, VXF_STATE_ADMIN, 0) &&
                               /* ... as long as there are tasks left */
                               (atomic_read(&vxi->vx_tasks) > 1))
                               sig = SIGINT;
               }
               /* fallthrough */
       default:
               rcu_read_lock();
               p = find_task_by_real_pid(pid);
               rcu_read_unlock();
               if (p) {
                       if (vx_task_xid(p) == vxi->vx_id)
                               retval = group_send_sig_info(sig, sip, p);
               }
               break;
       }
       read_unlock(&tasklist_lock);
       vxdprintk(VXD_CBIT(misc, 4),
               "vx_info_kill(%p[#%d],%d,%d,%ld) = %d",
               vxi, vxi->vx_id, pid, sig, (long)sip, retval);
       return retval;
}

vx_info_kill() is the only place that touches tasklist_lock that does not exist in mainline kernel. find_task_by_real_pid is just find_task_by_pid_ns(pid, &init_pid_ns).

The crash only happened once so far and AFAIK is not easily reproducible. Both the host and the guest were basically completely idle at that time.

So, am I on the right track or should I look elsewhere?

Best regards,
 Grzegorz Nosek

1. http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg57795.html
2. http://vserver.13thfloor.at/Experimental/patch-3.2.11-vs2.3.2.8.diff
