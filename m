Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2B2Tl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:41:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57973 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024Ab2B2Tlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:41:55 -0500
Message-ID: <1330544513.22235.6.camel@joe2Laptop>
Subject: checkpatch hangs, memset failures, and minimum versions
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 11:41:53 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andy.

There's a problem with the memset tests that cause
the checkpatch script to fail oddly.

This test:

# Check for misused memsets
		if (defined $stat &&
		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {

can sometimes never advance and can just consume cpu
so that the script hangs.

It works properly if $FuncArg (actually $LvalOrFunc)
is changed from

our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
our $lval_parens = qr/(\((?:[^\(\)]+|(-1))*\))/;

our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
our $LvalOrFunc	= qr{($Lval)\s*($lval_parens{0,1})\s*};
our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};

to

our $LvalOrFunc	= qr{($Lval)\s*($balanced_parens{0,1})\s*};

the balanced_parens use requires perl 5.10

This change can also help fix a problem with a --strict check
to calculate the correct position for a continuation line that
should align on an open parenthesis.  That test does require
an additional change though.

Suggestions?

