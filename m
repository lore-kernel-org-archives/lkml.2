Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0JaP3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:29:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57478 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031Ab0JaP3F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:29:05 -0400
Message-Id: <1288538943.19875.1402847217@webmail.messagingengine.com>
X-Sasl-Enc: f+okMLUQs9fXOw+17bLhL0wDxS9mmonMbSZbjYhQsRJo 1288538943
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@osdl.org,
        "David Howells" <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com><20101025140218.5092.74117.stgit@warthog.procyon.org.uk><28707.1288018465@redhat.com>
 <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
In-Reply-To: <4CC5B8D3020000780001EFB4@vpn.id2.novell.com>
Date: Sun, 31 Oct 2010 16:29:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 16:05 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> >>> On 25.10.10 at 16:54, David Howells <dhowells@redhat.com> wrote:
> > Jan Beulich <JBeulich@novell.com> wrote:
> > 
> >> Isn't this a gas bug then? Anywhere you use a plain number you
> >> should also be permitted to use an expression.
> > 
> > Whoever defined the gas assembly syntax for binutils specified that (N) as 
> > an
> > operand defines an absolute address and N defines an immediate value.
> > 
> > However, prefixing an expression with a unary plus works for me, so adding
> > this into my patch:
> > 
> > -	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
> > +	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 +(\2) /* \3 */:; \
> > 
> > Does that work for you?
> 
> Alexander, you seem to be having access to a worst case system -
> could you give this a try?

Hi all!

I'm just back from a week of vacation, so I missed the discussion completely.

I didn't check the version with the plus-sign, but the current state in linus' tree
compiles fine(*) with this ubuntu 6.06 image. So I'ld suggest to clean up the
sed-script to the old version and limp on a few more kernel versions, watch out
for checkpatch-improvements, and then try again to deprecate gas-2.16, notify
Andrew Morton he should get rid of it, and clean up the space-removals again.

(*) First try was with a UP-PREEMPT-mini.config and this one ended with:
In file included from /home/src/linux/linux-2.6/arch/x86/include/asm/suspend_32.h:10,
                 from /home/src/linux/linux-2.6/arch/x86/include/asm/suspend.h:2,
                 from /home/src/linux/linux-2.6/arch/x86/kernel/asm-offsets_32.c:21,
                 from /home/src/linux/linux-2.6/arch/x86/kernel/asm-offsets.c:2:
/home/src/linux/linux-2.6/arch/x86/include/asm/i387.h: In function ‘irq_ts_save’:
/home/src/linux/linux-2.6/arch/x86/include/asm/i387.h:325: error: implicit declaration of function ‘kernel_locked’
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1

Not sure if this is already known. Configuration:

The mini.config file:

CONFIG_EXPERIMENTAL=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_RCU_FANOUT=32
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="../initramfs.i386"
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_EMBEDDED=y
CONFIG_KALLSYMS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_PREEMPT=y
CONFIG_X86_MCE=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
CONFIG_RELOCATABLE=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_PROC_FS=y
CONFIG_SYSFS=y
CONFIG_FRAME_WARN=196
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_OPTIMIZE_INLINING=y

(can be expanded with "make KCONFIG_ALLCONFIG=mini.config allnoconfig")

Removing CONFIG_PREEMPT=y got things going.

Greetings,
   Alexander

> Thanks, Jan
> 
