Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768743Ab2KOTLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:11:18 -0500
Received: from nm30-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.194]:24900
	"EHLO nm30-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768590Ab2KOTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:11:15 -0500
X-Yahoo-Newman-Id: 384328.47798.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tWRvIToVM1lSlNSFp5p.vWvokMETHCXEhosEWX3XH8JVJZD
 vg1XyV8VaCK5l5Qqooyd8FS02l4zN_xYIGBln_w4fEDF_XwZXSBxoxLkPaV_
 MH3TCgnCXKN9K49.HD8Y6h09CpM2Wd4EDnqN_KLXoH.F..TGY4VNGIvUtN.8
 cXgdHr3KeyUTzVzFv9URaYQLzqhRyGywQCY8lNdbXGTKrDi4RPrybRgYH10o
 tTS_VNUelx..YnhyryZGCQYPo7DL06tA19xzsdN7PvH.HuUM0IxKrgaB83Gh
 kX3A5FsGUsEGh4VAsQVvwFKXljVcHeeTEHasOtB5wrFl1Wx1InaHPYHq54op
 HCkFG9hNC2tp7OepsKtAVh4wWh8uKbXx6kCmUi69_B_FXMAzAe82qcobqCSJ
 gyDj6zEyMIcQSqg2e4d7VGARt_gADT6cWKyJr1AOB6xfR43zRe3t63g4_GZ4
 HHxYYf9vXBP.kvvUZ.tPcQu7NOQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50A53E53.8080404@att.net>
Date: Thu, 15 Nov 2012 13:11:15 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com> <1352844821-18952-6-git-send-email-daniel.santos@pobox.com> <20121115150726.GD4956@x1.osrc.amd.com>
In-Reply-To: <20121115150726.GD4956@x1.osrc.amd.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 09:07 AM, Borislav Petkov wrote:
> On Tue, Nov 13, 2012 at 04:13:38PM -0600, danielfsantos@att.net wrote:
>> When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
>> the condition will be evaulated twice, possibily with side-effects.
>> This patch eliminates that error.
>>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>> ---
>>  include/linux/bug.h |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>> index 1b2465d..ccd44ce 100644
>> --- a/include/linux/bug.h
>> +++ b/include/linux/bug.h
>> @@ -58,8 +58,9 @@ struct pt_regs;
>>  extern int __build_bug_on_failed;
>>  #define BUILD_BUG_ON(condition)					\
>>  	do {							\
>> -		((void)sizeof(char[1 - 2*!!(condition)]));	\
>> -		if (condition) __build_bug_on_failed = 1;	\
>> +		bool __cond = !!(condition);			\
>> +		((void)sizeof(char[1 - 2*!!(__cond)]));		\
> No need for the !!(__cond) here because you've done it in the line
> above. IOW,
>
> 	bool __cond = !!(condition);
> 	((void)sizeof(char[1 - 2 * __cond]));
>
> which is even a bit more readable, as a matter of fact.
Ah yes. I did notice that at one point, but I think it slipped my mind. 
Also, the kernel has introduced me to the usage of the !! construct, of
which I'm well versed in its affects in various situations and how gcc's
optimizer ends up treating its usage, so probably another reason I
didn't change it immediately. But it's basically shorthand for the
expression (condition ? 1 : 0), correct? Or are there other details in
the C standard that makes it different in some cases?

Thanks,
Daniel
