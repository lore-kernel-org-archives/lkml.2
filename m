Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2I3X3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:29:03 -0400
Received: from nm23-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.224]:29747 "HELO
	nm23-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751388Ab2I3X3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:29:00 -0400
X-Yahoo-Newman-Id: 368090.8418.bm@omp1006.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hGmrFgMVM1m4YfePhlMRTUD1ZRyobgQ366l88Bp9rgPqueD
 T.O_hlNamWzGrBVB.L7nbtXhhZEX5iZOGu.KgO7AB_NYZUamq4v1ryZol4yl
 IlrWgzaCDLF6pWYuOUPFIi8bh6Rnhfrc0CFV4E4fHkaa4suhG7TxLdMd5od8
 Cwjwp_O6BxKlY7Nux9N7IclVYEWj0pac36x_nm8krt_kmHyYhYp6hPd1ZBxo
 q7lm0e4sHXRJFrQgbnlXFNjkVTaz4489ZeVcikCpAGchQ7sefVu3sHnrepeV
 o98En0qNzPZ1QR1kb1uogxJMvUAc6ezy2IWTzAc7WEoNLtahQqF9yM7LhQOU
 Mqtefb7WSugJGu6jJdatPnl1Ob6hrRfp2IEI1BGcC03A8gHKRU7hbNPk6eTh
 y4h2U4QdyGTyN7qBPJ3HAEndf6mXxRLTgF2.08Vd4WNoULXYZxg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5068D5BD.1000802@att.net>
Date: Sun, 30 Sep 2012 18:29:01 -0500
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
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-9-git-send-email-daniel.santos@pobox.com> <20120929003239.GA14293@jtriplet-mobl1> <50664E30.7050809@att.net> <20120929025506.GA3183@leaf>
In-Reply-To: <20120929025506.GA3183@leaf>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 09:55 PM, Josh Triplett wrote:
> Assuming you don't call BUILD_BUG_ON_MSG more than once per line:
>
> /tmp$ cat test.c
> #define BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line) \
>     do { \
>         extern void __build_bug_on_failed_ ## line (void) __attribute__((error(msg))); \
>         if (cond) \
>             __build_bug_on_failed_ ## line(); \
>     } while (0)
>
> #define BUILD_BUG_ON_MSG_INTERNAL(cond, msg, line) BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line)
> #define BUILD_BUG_ON_MSG(cond, msg) BUILD_BUG_ON_MSG_INTERNAL(cond, msg, __LINE__)
>
> void f(void)
> {
>     BUILD_BUG_ON_MSG(0, "test 1");
>     BUILD_BUG_ON_MSG(1, "test 2");
>     BUILD_BUG_ON_MSG(0, "test 3");
>     BUILD_BUG_ON_MSG(1, "test 4");
> }
> /tmp$ gcc -c test.c
> test.c: In function ‘f’:
> test.c:14:119: error: call to ‘__build_bug_on_failed_14’ declared with attribute error: test 2
> test.c:16:119: error: call to ‘__build_bug_on_failed_16’ declared with attribute error: test 4
Thanks! This is very nice!  I've done a little more research and
discovered that there's also a __COUNTER__ macro that is available
in gcc 4.3+.  Before I realized that it was only available in gcc
4.3, I wrote this little macro:

#define _CONCAT1(a, b) a##b
#define CONCAT(a, b) _CONCAT1(a, b)

#ifdef __COUNTER__
# define UNIQUIFY(prefix) CONCAT(prefix, __COUNTER__)
#else
# define UNIQUIFY(prefix) CONCAT(prefix, __LINE__)
#endif

However, this could lead to code might compile on gcc 4.3+, but
not compile prior, so this is bad, right?

Daniel

