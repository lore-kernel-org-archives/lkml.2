Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2DYKr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:47:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2DYKrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:47:55 -0400
Date: Wed, 25 Apr 2012 07:48:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
Message-ID: <20120425104800.GC17992@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
 <20120425070537.GA29496@gmail.com>
 <20120425103132.GB17992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425103132.GB17992@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the bandaid, I see some strange constructs like (press 'o' to view
the original disassembly):

    0.00 ||  399f877dc6:v je     399f877dd5 <_int_free+0x735>
    0.00 ||  399f877dc8:  lock   decl (%r12)
    0.00 |+------877dcd:^ jne    399f87bd64 <_L_unlock_5659>
    0.00 |   399f877dd3:v jmp    399f877ddf <_int_free+0x73f> 

There is a bug above, the start_width for the arrow is bigger than it
should, will fix.

Pressing 'o' again this becomes:

    0.00 ||      v je     735
    0.00 ||        lock   decl (%r12)
    0.00 |+------^ jne    0
    0.00 |       v jmp    73f 

The 'jne 0' line, its a misparse of the <....> part, it ass-umed that a
+ was there all the time, which is not true, so I should instead do a
fixup when traversing the ->offsets array, looking for dl->target.ops =
0 and, since we know where the symbol starts at that point, fix it.

- Arnaldo
