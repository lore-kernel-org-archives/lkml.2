Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0IWSP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0IWSP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:15:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4013.1285177436@redhat.com>
References: <4013.1285177436@redhat.com> <25759.1285169592@redhat.com> <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com> <20100907180025.GD2662@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: checkpatch problem
Date: Thu, 23 Sep 2010 19:15:39 +0100
Message-ID: <22516.1285265739@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem is that the second matcher (looking for " to \\n) matches on more
than just the logfunction line.  Instrumenting the code supplied by your patch
thusly:

		if ($line =~ /^.*($logFunctions)/) {
		    print "QQQQ $1 QQQQ\n";
			my $ln = $linenr;
			my $cnt = $realcnt;
			my ($off, $dstat, $dcond, $rest);
			($dstat, $dcond, $ln, $cnt, $off) =
				ctx_statement_block($linenr, $realcnt, 0);
			for (my $n = 0; $n < $cnt; $n++) {
			    my $l = $rawlines[$ln-1+$n];
			    if ($l =~ /(\".*[ \t]\\n)/) {
				print "&&&$line&&&\n";
				print "^^^^^ Matched '$1' ^^^^^\n";
				WARN("Logging function has unnecessary whitespace before a newline\n" . $herecurr);
			    }
			}
		    }

I see:

QQQQ printk QQQQ
QQQQ printk QQQQ
QQQQ printk QQQQ
QQQQ printk QQQQ
QQQQ printk QQQQ
&&&+#define Dprintk(fmt, ...) printk(KERN_DEBUG fmt, ##__VA_ARGS__)&&&
^^^^^ Matched '"mov	%0,sp	\n' ^^^^^
&&&+#define Dprintk(fmt, ...) printk(KERN_DEBUG fmt, ##__VA_ARGS__)&&&
^^^^^ Matched '"jmp	(%1)	\n' ^^^^^
&&&+#define Dprintk(fmt, ...) printk(KERN_DEBUG fmt, ##__VA_ARGS__)&&&
^^^^^ Matched '"	movhu	(%1),%0	\n' ^^^^^


It seems that it doesn't like a #define dealing with a logging function
followed by an inline asm statement that has whitespace before '\\n'.

I suspect checkpatch doesn't handle #defines correctly, and goes beyond their
end looking for a semicolon.

David
