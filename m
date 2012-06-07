Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408Ab2FGTcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:32:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2FGTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:32:20 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=RcwUMuyEaQwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=7QN3BhfgatrIv94iBCYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339097538.13377.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 3/4] mips-remove-smp-reserve-lock.patch
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 07 Jun 2012 15:32:18 -0400
In-Reply-To: <4FD0FC26.3030101@gmail.com>
References: <20120607155148.698959275@goodmis.org>
		 <20120607155221.836885041@goodmis.org> <4FD0E9F9.60906@gmail.com>
	 <1339095399.13377.2.camel@gandalf.stny.rr.com> <4FD0FC26.3030101@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 12:08 -0700, David Daney wrote:

> > Should it go to mainline stable?
> >
> 
> I don't think it is necessary.  As far as I know, RT may be the only 
> thing that needs it.

Ah, you're right. As this is just an issue because it is called with
interrupts disabled (from stop_machine). Although it's interesting that
the mips code, re-enables interrupts from that function.

>From kernel/cpu.c:

_cpu_down() {
	 __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));

take_cpu_down() {
	err = __cpu_disable();

kernel/stop_machine.c:

__stop_machine(int (*fn)(void *) ...) {
	local_irq_save(flags);
	hard_irq_disable();
	ret = (*fn)(data);
	local_irq_restore(flags);


arch/mips/include/asm/smp.h:

static inline int __cpu_disable(void)
{
        extern struct plat_smp_ops *mp_ops;     /* private */

        return mp_ops->cpu_disable();
}

arch/mips/cavium-octeon/smp.c:

octeon_cpu_disable(void) {
        local_irq_disable();
        fixup_irqs();
        local_irq_enable();

struct plat_smp_ops octeon_smp_ops = {
        .cpu_disable            = octeon_cpu_disable,


Is this expected? It causes the cpu notifiers to be called with
interrupts enabled. Not sure if that's a problem or not.

-- Steve


