Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1JYME2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:04:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36487 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab1JYME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:04:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: holzheu@linux.vnet.ibm.com
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, akpm@linux-foundation.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1319468137.3615.16.camel@br98xy6r>
	<m1ipneifqv.fsf@fess.ebiederm.org>
	<CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
	<m1aa8qfhdk.fsf@fess.ebiederm.org> <1319532245.3056.5.camel@br98xy6r>
Date: Tue, 25 Oct 2011 05:04:57 -0700
In-Reply-To: <1319532245.3056.5.camel@br98xy6r> (Michael Holzheu's message of
	"Tue, 25 Oct 2011 10:44:05 +0200")
Message-ID: <m17h3tcm52.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VvWdQmqqYDC1dAr69YzOUWYNc4OtsTzI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;holzheu@linux.vnet.ibm.com
X-Spam-Relay-Country: **
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:

> Hello Eric,
>
> On Mon, 2011-10-24 at 10:07 -0700, Eric W. Biederman wrote:
>
> [snip]
>
>> So my second thought is to introduce another atomic variable
>> panic_in_progress, visible only in panic.  The cpu that sets
>> increments panic_in_progress can call smp_send_stop.  The rest of
>> the cpus can just go into a busy wait.  That should stop nasty
>> fights about who is going to come out of smp_send_stop first.
>
> So this is a spinlock, no? What about the following patch:
Do we want both panic printks?

We really only need the mutual exclusion starting just before
smp_send_stop so that is where I would be inclined to put it.

But yeah something like the below should work.

Eric


> ---
>  kernel/panic.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
>   */
>  NORET_TYPE void panic(const char * fmt, ...)
>  {
> +	static DEFINE_SPINLOCK(panic_lock);
>  	static char buf[1024];
>  	va_list args;
>  	long i, i_next = 0;
> @@ -68,8 +69,12 @@ NORET_TYPE void panic(const char * fmt,
>  	 * It's possible to come here directly from a panic-assertion and
>  	 * not have preempt disabled. Some functions called from here want
>  	 * preempt to be disabled. No point enabling it later though...
> +	 *
> +	 * Only one CPU is allowed to execute the panic code. For multiple
> +	 * parallel invocations of panic all other CPUs will wait on the
> +	 * panic_lock. They are stopped afterwards by smp_send_stop().
>  	 */
> -	preempt_disable();
> +	spin_lock(&panic_lock);
>  
>  	console_verbose();
>  	bust_spinlocks(1);
