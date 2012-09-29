Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2I2B0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 21:26:10 -0400
Received: from nm38-vm6.bullet.mail.bf1.yahoo.com ([72.30.239.22]:23771 "HELO
	nm38-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758342Ab2I2B0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 21:26:08 -0400
X-Yahoo-Newman-Id: 962794.94240.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y3nQXuoVM1nEgKxKoHhnif17SuT9RswcUnBtl57dNW9Pu7T
 k82u4LZ.FkPwdzgXvokFDpszTe2fowyyISD7Vt7.Ljjey75RmazZjgbeQkRy
 GGZwVjkKI6mNogbeN2RvYiYuV6HL2BP33.N.0muKQKV.DJ7udEX1KCkc6jEb
 VVCSAlrPdyCGbaby9RI3Gcetrh7nNIbJBFrQ17PUVG.BqwYbhztTneKVEykT
 Ql5pgF0wUZ8F0eckPP99V55eXrVUovAJnghLjotvtu3_Glf.EKgYzL1BG4cR
 sxaYkPCAkkEZeugq9rct7bPrCWxVno5XGOBPiVx1m5opS04UGhk1i.1IBcJV
 nFn2R6YYxA6TvYYwwU9phv3oBXZPuCrB5ULPq8ajXGsk8sNW0ZqzCkdVB.NX
 n4WYRJo5Yf5QgNEgAKG9L4XkOZo3_bWrar1BYHPjpodAnINL7BA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50664E30.7050809@att.net>
Date: Fri, 28 Sep 2012 20:26:08 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/10] bug.h: Make BUILD_BUG_ON generate compile-time error
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-9-git-send-email-daniel.santos@pobox.com> <20120929003239.GA14293@jtriplet-mobl1>
In-Reply-To: <20120929003239.GA14293@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:32 PM, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:09PM -0500, Daniel Santos wrote:
>> Negative sized arrays wont create a compile-time error in some cases
>> starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
>> the error function attribute that will.  This patch modifies
>> BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
>> function attribute so that you don't have to build the entire kernel to
>> discover that you have a problem, and then enjoy trying to track it down
>> from a link-time error.
>
> Rather than doing both, and potentially producing two errors for the
> same issue, how about using __compiletime_error only, and only using the
> negative-sized array when __compiletime_error has no useful definition?
>
> For instance, in compiler.h, when defining __compiletime_error as an
> empty macro in the fallback case, you could define a
> __compiletime_error_fallback() macro that declares a negative-sized
> array; you could then define __compiletime_error_fallback() as an empty
> macro when it doesn't exist.
It may also make sense to define
#define BUILD_BUG() BUILD_BUG_ON(1)

I haven't examined this really closely yet and my eyes are getting a
little bleary :)


Really, I would have liked to be able to set the error message as
well, but we would have to have the macro generate a unique function
name for each time its expanded to make that work.  Example:

#define BUILD_BUG_ON(cond) BUILD_BUG_ON_MSG(cond, #cond)
#define BUILD_BUG_ON_MSG(cond, msg)                                \
    do {                                                           \
        extern void __build_bug_on_failed ## something_unique(void)\
            __compiletime_error("BUILD_BUG_ON failed: " msg);      \
        __compiletime_error_fallback(cond);                        \
        if (cond)                                                  \
            __build_bug_on_failed();                               \
    } while(0)

I just don't know any tricks to generate unique pre-processor
value automatically.

Daniel
