Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0KCHNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:13:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63733 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0KCHN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ghY51gTxiNxNmOw4xifXj88h+9LAo0g0XW7IriXiz9mkjCaU+3Ze/nuU76BrUJR5W/
         o0iN6hmoiiDOoA56fPVP1BiwzBIy36aXW4/OpGztvfbm+klCysoArT3t29GIJDD+hN0Y
         T/vNe9XuqN0pGyR1iosiD3zYTAFyfhHDoyHE4=
Subject: Re: [regression, 2.6.37-rc1] 'ip link tap0 up' stuck in do_exit()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20101103062609.GB31163@dastard>
References: <20101103062609.GB31163@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 08:13:22 +0100
Message-ID: <1288768402.2467.665.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 17:26 +1100, Dave Chinner a écrit :
> Folks,
> 
> Starting up KVM on a current mainline kernel using the tap
> device for the networking is resulting in the ip process tryin gto
> up the tap interface hanging. KVM is started with this networking
> config:
> 
> ....
>         -net nic,vlan=0,macaddr=00:e4:b6:63:63:6d,model=virtio \
>         -net tap,vlan=0,script=/vm-images/qemu-ifup,downscript=no \
> ....
> 
> And the script is effectively:
> 
> switch=br0
> if [ -n "$1" ];then
>         /usr/bin/sudo /sbin/ip link set $1 up
>         sleep 0.5s
>         /usr/bin/sudo /usr/sbin/brctl addif $switch $1
> 	exit 0
> fi
> exit 1
> 
> This is resulting in the command 'ip link set tap0 up' hanging as a zombie:
> 
> root      3005     1  0 16:53 pts/3    00:00:00 /bin/sh /vm-images/qemu-ifup tap0
> root      3011  3005  0 16:53 pts/3    00:00:00 /usr/bin/sudo /sbin/ip link set tap0 up
> root      3012  3011  0 16:53 pts/3    00:00:00 [ip] <defunct>
> 
> In do_exit() with this trace:
> 
> [ 1630.782255] ip            x ffff88063fcb3600     0  3012   3011 0x00000000
> [ 1630.789121]  ffff880631328000 0000000000000046 0000000000000000 ffff880633104380
> [ 1630.796524]  0000000000013600 ffff88062f031fd8 0000000000013600 0000000000013600
> [ 1630.803925]  ffff8806313282d8 ffff8806313282e0 ffff880631328000 0000000000013600
> [ 1630.811324] Call Trace:
> [ 1630.813760]  [<ffffffff8104a90d>] ? do_exit+0x716/0x724
> [ 1630.818964]  [<ffffffff8104a995>] ? do_group_exit+0x7a/0xa4
> [ 1630.824512]  [<ffffffff8104a9d1>] ? sys_exit_group+0x12/0x16
> [ 1630.830149]  [<ffffffff81009a82>] ? system_call_fastpath+0x16/0x1b
> 
> The address comes down to the schedule() call:
> 
> (gdb) l *(do_exit+0x716)
> 0xffffffff8104a90d is in do_exit (kernel/exit.c:1034).
> 1029            preempt_disable();
> 1030            exit_rcu();
> 1031            /* causes final put_task_struct in finish_task_switch(). */
> 1032            tsk->state = TASK_DEAD;
> 1033            schedule();
> 1034            BUG();
> 1035            /* Avoid "noreturn function does return".  */
> 1036            for (;;)
> 1037                    cpu_relax();    /* For when BUG is null */
> 1038    }
> 
> Needless to say, KVM is not starting up. This works just fine on
> 2.6.35.1 and so is a regression. I can't do a lot of testing on this as
> the host is the machine that hosts all my build and test environments....
> 
> Cheers,
> 
> Dave.

Could it be the same problem than 

http://kerneltrap.com/mailarchive/linux-netdev/2010/10/23/6288128

Try to revert bee31369ce16fc3898ec9a54161248c9eddb06bc ?

Thanks



