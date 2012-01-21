Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2AUVTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 16:19:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50524 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2AUVTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 16:19:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAO+b5-qsdn8i_BdAqJo_6CU3Lh6JTPSSsyg-m_bP+xcN5aBgxg@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
	<CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
	<CAO+b5-pZofpN7-e8H+toE98j24fby5u8_Nzfzkz_S31u5wDmwA@mail.gmail.com>
	<CAGAKE88--L1igeZFusU=TxRD6fyfKWZYhn7az6-xkS_mtVg8CA@mail.gmail.com>
	<CAGAKE8_b_Omxzg4C-VMiuM9aEhnRPkPD9=5DW9retGfcfOhBuQ@mail.gmail.com>
	<CAGAKE8-3k0FN5B91ff2XFpYuHfwB-bmr4b7EBEe-aSWfQr1mSw@mail.gmail.com>
	<CAO+b5-qsdn8i_BdAqJo_6CU3Lh6JTPSSsyg-m_bP+xcN5aBgxg@mail.gmail.com>
Date: Sat, 21 Jan 2012 23:19:02 +0200
Message-ID: <CAGAKE886que4x4h7N7fszGQXKE3Fej_yAShjOiKEEZrL5Gocbw@mail.gmail.com>
Subject: Re: [Scst-devel] BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: kordex <kordex@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, LKML <linux-kernel@vger.kernel.org>,
        mingo@elte.hu, peterz@infradead.org, kvm@vger.kernel.org,
        avi@redhat.com, scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 18:11, Bart Van Assche <bvanassche@acm.org> wrote:
> On Sat, Jan 21, 2012 at 2:58 PM, kordex <kordex@gmail.com> wrote:
>> On Thu, Jan 19, 2012 at 21:12, kordex <kordex@gmail.com> wrote:
>> > On Thu, Jan 19, 2012 at 20:34, kordex <kordex@gmail.com> wrote:
>> >> Full dmesg of the case attached.
>> >> On Thu, Jan 19, 2012 at 13:12, Bart Van Assche <bvanassche@acm.org> wrote:
>> >>> On Thu, Jan 19, 2012 at 11:54 AM, kordex <kordex@gmail.com> wrote:
>> >>>> > root@teletex:/usr/src/linux# dmesg
>> >>>> > +0x12e7/0x1c50
>> >>>> >  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0
>> >>>
>> >>> The above output is truncated - the most interesting part is missing.
>>
>> Do I need to give you anything else? Any leads on what the problem
>> might be? The machine is still running and in this state.
>
> In the /proc/meminfo output I see that the system has 16 GB RAM and 33
> GB swap memory. Also, MemFree + Buffers = 400 KB, which makes me
> assume the system was under heavy memory pressure ?
>
> Some essential information is still missing - the reason why the
> kernel started spewing out all these call traces. Did someone hit the
> SysRq key ? Is it because a task was hanging ? Was a BUG or WARNING
> hit ?
>
> Bart.

I hit sysrq+t sysrq+p in order to print the tasks with stacktraces and
registers. Using ps -e -o  pid,state,command will hang ps output,
while ps -e -o pid,state will not.

Last line out from ps -ef is:
 3102 S /usr/sbin/console-kit-daemon --no-daemon
Next one should be:
kordex@teletex:/proc$ cat 4119/comm
kvm
Doing root@teletex:/proc/4119# cat environ or cat cmdline will hang
the terminal, just like with ps.

About the memory usage:
kordex@teletex:~$ cat /proc/sys/vm/swappiness
60
kordex@teletex:~$ free -m
             total       used       free     shared    buffers     cached
Mem:         15965      15833        131          0        133         29
-/+ buffers/cache:      15670        294
Swap:        32767       3366      29401

top processes sorted by memory usage:

top - 23:03:07 up 20 days,  2:53,  4 users,  load average: 81.08, 79.74, 78.75
Tasks: 278 total,   1 running, 275 sleeping,   0 stopped,   2 zombie
Cpu(s):  2.1%us,  1.7%sy,  0.0%ni, 48.1%id, 48.1%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  16348324k total, 16214044k used,   134280k free,   137012k buffers
Swap: 33554428k total,  3447372k used, 30107056k free,    30080k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
10150 libvirt-  20   0 4584m 3.1g  740 S    2 19.6 678:53.51 kvm
 6051 libvirt-  20   0 4489m 1.8g  676 S    3 11.5   6046:48 kvm
 9853 libvirt-  20   0 3568m  43m  824 S    6  0.3 891:26.22 kvm
 6291 libvirt-  20   0 2047m 327m  480 S    2  2.1 294:26.91 kvm
 7273 libvirt-  20   0 1874m  15m 1812 D    0  0.1   0:00.09 kvm
 5423 libvirt-  20   0 1105m 7880  412 S    0  0.0 256:52.54 kvm
 6915 libvirt-  20   0 1023m 129m  356 S    0  0.8 327:47.85 kvm
 5921 libvirt-  20   0  994m  61m  348 S    2  0.4 335:29.19 kvm
 4119 libvirt-  20   0  961m  99m  372 D    0  0.6 470:42.29 kvm
 6873 libvirt-  20   0  575m 101m  672 S    2  0.6 328:05.80 kvm
 6166 libvirt-  20   0  567m  11m  344 S    0  0.1 275:25.91 kvm
 6642 libvirt-  20   0  560m  92m  376 D    0  0.6 269:03.14 kvm
 4225 libvirt-  20   0  548m 7312   76 S    3  0.0 335:52.23 kvm
 4352 libvirt-  20   0  525m  13m  520 S    3  0.1 344:22.53 kvm
 6726 libvirt-  20   0  519m 116m  372 S    3  0.7 352:13.64 kvm
 6964 libvirt-  20   0  464m  91m  504 S    3  0.6 337:30.12 kvm

Br,
-Mikko Kortelainen
