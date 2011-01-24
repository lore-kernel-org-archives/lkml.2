Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1AXTcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:32:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44531 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1AXTcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TImj+ynkys09XtMKqo3zzFkDbo49w2RyeRx/8McWgH1EgzKHEmFQctOXckiMDAAu7l
         EqwgOpcCxuc1iZsdugUQsOzL+dAbeTxTLd1L5FIf4bBsZOrB0G8ZoYBgulJb89HSiLJl
         GFEn3V5Lv3gG0EhNtzU5MK3e5nb5oFfAnZS+w=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=hJh58BbMQcv3_4fzNzP49v2am2VYNFM4eHETC@mail.gmail.com>
References: <AANLkTikVO43T7NS4W4sFtZLcFKzTK1N26NHGmtcDViD+@mail.gmail.com>
	<AANLkTin-jpDKfSAEJFgMG5dYE0H5kSP3v53T3t92Erq=@mail.gmail.com>
	<AANLkTi=--R3Qjrb7iKLZa6KWZ1b19o9ZOeK2Bhd=ziZN@mail.gmail.com>
	<AANLkTi=hJh58BbMQcv3_4fzNzP49v2am2VYNFM4eHETC@mail.gmail.com>
Date: Mon, 24 Jan 2011 14:32:45 -0500
Message-ID: <AANLkTikaJKhvjVg0wHqrdmj_gQ2BEB9=wcFb_tQMTu5k@mail.gmail.com>
Subject: Re: Messaging
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: anil joshi <anilsjoshi123@gmail.com>
Cc: linux-newbie@vger.kernel.org,
        Linux-rt-users <linux-rt-users@vger.kernel.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anil,

    Thanks for your response. There are many implementation of
messaging in kernel. I am looking for specific implementation of Linux
kernel.
So, If I am not wrong, from your structures you posted, it seems Linux
is implementing using file system. Lets make this an assumption and
post it to groups.

Please if anyone has idea of messaging implementation, please let us know.

Thanks,
Sri.

On Sun, Jan 23, 2011 at 3:48 PM, anil joshi <anilsjoshi123@gmail.com> wrote:
> I would like to share my knowledge with you  if any technical error
> please suggest me
>
> As in Process management
>
> struct thread_info {
>         struct task_struct      *task;          /* main task structure */
>         struct exec_domain      *exec_domain;   /* execution domain */
>         __u32                   flags;          /* low level flags */
>         __u32                   status;         /* thread synchronous flags */
>         __u32                   cpu;            /* current CPU */
>         int                     preempt_count;  /* 0 => preemptable,
>                                                   <0 => BUG */
>         mm_segment_t            addr_limit;
>         struct restart_block    restart_block;
>         void __user             *sysenter_return;
>  #ifdef CONFIG_X86_32
>         unsigned long           previous_esp;   /* ESP of the previous stack in
>                                                    case of nested (IRQ) stacks
>                                                 */
>         __u8                    supervisor_stack[0];
>  #endif
>         int                     uaccess_err;
>  };
>
>
>
>
> struct task_struct  {
>
> -----
> --
> -
> ----
> -----
> }
>
>
> in a similar fashion  File System Management in that VFS
> the four Primary object of VFS are
> (courtesy  by Robert  Love Linux kernel Dev elopement)
> super block object  -> represent mounted file system (contained in
> struct vfsmount)
> i node object -> represent a specific  file
>
> d entry object -> represent directory entry, a single component of a path
> fiie object -> open file as associated with process
>
> Layered approach
> Object of struct mqueue_inode_info layered  on Object of struct inode
> (vfs_inode)
>
> or
>
> Object of struct inode (vfs_inode)  contained in struct mqueue_inode_info
>
>
>
> it contain particular message specific information like
>
> $ ls /dev/mqueue/mymq
> QSIZE:129     NOTIFY:2    SIGNO:0    NOTIFY_PID:8260
>
>
>
> struct mqueue_inode_info {
>        spinlock_t lock;
>        struct inode vfs_inode;
>        wait_queue_head_t wait_q;
>
>        struct msg_msg **messages;
>        struct mq_attr attr;
>
>        struct sigevent notify;
>        struct pid* notify_owner;
>        struct user_struct *user;       /* user who created, for accounting */
>        struct sock *notify_sock;
>        struct sk_buff *notify_cookie;
>
>        /* for tasks waiting for free space and messages, respectively */
>         struct ext_wait_queue e_wait_q[2];
>
>         unsigned long qsize; /* size of queue in memory (sum of all msgs) */
>  };
>
> struct inode  {
>  ----
> ----
> ----
> }
>
>
> we used the generic inode structure as the inode layer does not need
> to know about the  /dev/mqueue/mymq stucture(mqueue_inode_info)
>
> flush
> unlnk
> look up
> mqueue_poll_file,
> mqueue_read_file
> are specific to mqueue inode
> static const struct inode_operations mqueue_dir_inode_operations = {
>        .lookup = simple_lookup,
>        .create = mqueue_create,
>       .unlink = mqueue_unlink,
>  };
>
> static const struct file_operations mqueue_file_operations = {
>        .flush = mqueue_flush_file,
>        .poll = mqueue_poll_file,
>        .read = mqueue_read_file,
>  };
>
> inode->i_fop = &mqueue_file_operations;
> inode->i_op = &mqueue_dir_inode_operations;
>
>
> refer http://bec-systems.com/web/content/view/94/9/
> http://www.kroah.com/log/linux/container_of.html
>
> if u know more regarding mqueue share it
>
> Regards
> Anil.S.Joshi
>



-- 
Regards,
Sri.
