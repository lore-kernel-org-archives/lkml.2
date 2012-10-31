Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2JaFsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:48:23 -0400
Received: from nm15-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.17]:48317
	"EHLO nm15-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab2JaFsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:48:20 -0400
X-Yahoo-Newman-Id: 966628.85241.bm@smtp107.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MbS7QLcVM1nXxSPPZAza38q0jJLW2gxpLEmdmEQBqTLiMsf
 7NHSDzHDBnCI83BCR3AkIgNhGwmFfNT637cI4KEg4Nw2CACqQZodIHDQbdfK
 _.YoB8FCUsuCf5QdZjXa8bNTTqF4Qi5OA3zcHnUFLVIfX0VaqTtk0jo6o3vP
 PZe0a9oEZEGYQwvguS6oWZnmPStZ.7P96vCBWUrntTNRfVADKO8LQxUMGQir
 8XIEUcNV07r_e7DSTQfDDIEhodPIjv8NRB4EFXXsDYuB5T9UaxocAs3iVzHq
 Hc4v1crdiAuPnvAwFCRAg704CXWE8xP_cBz43FwMxhPdBDpEsTHgoQEmL87j
 GkAfxQzvPKPmWQD.vrCF0TAiVCx8K3v6bblpyk0syg9QIGd7mZllGegR9cp9
 wwJGNcAsKgZ_loFq_F3zQgUEYxD4yDWpSKntpiGpxlHP2eRbOXI1q1Az7qlE
 m.D8GAefEb9WDXzKu46ExSCP.bg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5090BBB6.6080607@att.net>
Date: Wed, 31 Oct 2012 00:48:38 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Borislav Petkov <bp@alien8.de>, Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 9/9] bug.h: Convert BUILD_BUG{,_ON} to use BUILD_BUG_ON_MSG
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com> <1351457835-7553-9-git-send-email-daniel.santos@pobox.com> <20121030191905.GG28499@liondog.tnic> <20121031010232.GA18229@leaf>
In-Reply-To: <20121031010232.GA18229@leaf>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 08:02 PM, Josh Triplett wrote:
> On Tue, Oct 30, 2012 at 08:19:05PM +0100, Borislav Petkov wrote:
>> On Sun, Oct 28, 2012 at 03:57:15PM -0500, danielfsantos@att.net wrote:
>>> Remove duplicate code by converting BUILD_BUG and BUILD_BUG_ON to just
>>> call BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but
>>> also prevents the possibility of code being changed for one macro and
>>> not for the other (which was previously the case for BUILD_BUG and
>>> BUILD_BUG_ON).
>>>
>>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>>> ---
>>>  include/linux/bug.h |   17 +++--------------
>>>  1 files changed, 3 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>>> index 3bc1ddf..b58ba51 100644
>>> --- a/include/linux/bug.h
>>> +++ b/include/linux/bug.h
>>> @@ -81,14 +81,8 @@ struct pt_regs;
>>>  #ifndef __OPTIMIZE__
>>>  #define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
>>>  #else
>>> -#define BUILD_BUG_ON(condition)						\
>>> -	do {								\
>>> -		extern void __build_bug_on_failed(void)			\
>>> -			__compiletime_error("BUILD_BUG_ON failed");	\
>>> -		__compiletime_error_fallback(condition);		\
>>> -		if (condition)						\
>>> -			__build_bug_on_failed();			\
>>> -	} while(0)
>>> +#define BUILD_BUG_ON(condition) \
>>> +	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>> Concatenating "condition" might not be very informative in all cases.
>> For example:
>>
>> BUILD_BUG_ON(1);
>>
>> Having __LINE__ is good enough IMHO.

Honestly, __LINE__ is only used to keep the function name unique.  If
anything, I think that having it creates more confusion rather than adds
clarity since the error message will indicate the file and line number
anyway.  So in other words, it is redundant without it being apparent
why.  Of course, it's a very simple and portable mechanism to keep the
symbols unique.  IMO, using __COUNTER__would be better for clarity
(since the number wouldn't relate to the anything real), but it is not
portable across versions of gcc (introduced in 4.4 or some such), so we
are using __LINE__.

> While it doesn't always help, it may help sometimes.  Worst case,
> BUILD_BUG_ON(1) gives you no less information than it did before; best
> case, it gives you useful data.

Yeah, and depending upon what it's fed (and how much pre-processing had
been done on that) it can actually prove helpful because stringifying
condition can reveal pre-processing errors as well.  So if you passed
some macro as the condition and it didn't expand the way you expected,
this error message will print out exactly how it expanded, up to the
point of having been passed to BUILD_BUG_ON.  I don't know how much that
could potentially help, but for troubleshooting, I find extra
information helpful, more often than harmful.

Daniel
