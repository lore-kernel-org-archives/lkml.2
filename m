Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2DTK7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:59:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57532 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2DTK7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:59:02 -0400
Date: Fri, 20 Apr 2012 07:59:02 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
Message-ID: <20120420105902.GC9679@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
 <CA+55aFxY0MWR2vTRwf7a6+wm0gXet-X+i11=V_OapneciTJJMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxY0MWR2vTRwf7a6+wm0gXet-X+i11=V_OapneciTJJMg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 19, 2012 at 05:31:04PM -0700, Linus Torvalds escreveu:
> On Thu, Apr 19, 2012 at 1:33 PM, Arnaldo Carvalho de Melo wrote:
> Ok, so I did a quick test-run, and things are definitely more readable.
> 
> However, from a "where is the loop" angle, the one thing that is
> actually fairly hard to visually see is the branches.
>
> Sure, you can find them, but they are not nearly as easy to pick out
> visually as the branch targets are, and I do wonder if it wouldn't
> make sense to try to make them stand out a bit more.
> 
> What is visually important is
>  (a) seeing that it's a branch
>  (b) seeing the direction of the branch (to pick up on loops more easily).
> 
> I suspect that doing a whole arrow is just going to be a horrible
> criss-crossing mess (although with some graphical UI it might not be
> as bad as with the textual one), but I think even just doing it in
> entirely local scope of the particular line that contains the branch
> would be perfectly fine.

You mean we could draw the arrow all the way from the branch to the
label when the cursor is on one of them (branch, label)?

It would avoid the criss-crossing mess, and with identing it would get
even easier to draw it, i.e. it would be a straight line with a tip just
below the branch and a "feather" just above the target label.
 
> This, for example, is a snippet of a pretty simple function
> (avc_lookup()) with a few branches and a few branch targets:
> 
>     2.08 │      test   %rdx,%rdx
>     0.00 │      jne    38
>     0.00 │      jmp    53
>     5.13 │ 30:  mov    (%rdx),%rdx
>     0.74 │      test   %rdx,%rdx
>     0.00 │      je     53
>     0.06 │ 38:  lea    -0x20(%rdx),%rax
>    59.64 │      cmp    -0x20(%rdx),%edi
>     0.40 │      jne    30
>    17.36 │      cmp    -0x18(%rdx),%cx
>     0.00 │      jne    30
>     1.91 │      cmp    0x4(%rax),%esi
>     0.00 │      jne    30
>     0.22 │      test   %rax,%rax
>     0.20 │      je     53
>     1.68 │      leaveq
>     1.90 │      retq
>     0.00 │ 53:  incl   %gs:0xe214
>     0.00 │      xor    %eax,%eax
> 
> and the branch targets are fairly easy to pick up, but seeing the
> branches - and their directions - themselves takes much more parsing.
> Ok, it's actually pretty simple above, because they have a faily
> obvious pattern, but in bigger functions they really are harder to
> pick out.
> 
> Now, what if the branch instruction was just followed with a simple
> "arrow up/down" thing, and to make the distinction really simple to
> see visually, make the indentation slightly different for the
> back/forwards case, so that you don't have to really look at the
> (crappy) arrow head to find possible loops (backwards jumps).
> 
> The above snippet would then become:
> 
>     2.08        test   %rdx,%rdx
>     0.00        jne    38                  ----v
>     0.00        jmp    53                  ----v
>     5.13   30:  mov    (%rdx),%rdx
>     0.74        test   %rdx,%rdx
>     0.00        je     53                  ----v
>     0.06   38:  lea    -0x20(%rdx),%rax
>    59.64        cmp    -0x20(%rdx),%edi
>     0.40        jne    30                      ----^
>    17.36        cmp    -0x18(%rdx),%cx
>     0.00        jne    30                      ----^
>     1.91        cmp    0x4(%rax),%esi
>     0.00        jne    30                      ----^
>     0.22        test   %rax,%rax
>     0.20        je     53                  ----v
>     1.68        leaveq
>     1.90        retq
>     0.00   53:  incl   %gs:0xe214
>     0.00        xor    %eax,%eax
> 
> where I think it's fairly easy to pick up the branches. Sure, once you
> really need to connect them, you do need to compare the offsets (easy
> in the above case, less obvious with big complex functions), but just
> making it easy to *see* the backwards branches makes it easier to see
> the loop, methinks.
> 
> I dunno. Just a suggestion. I definitely like the new format better
> already, regardless of any arrows.

Great, keep suggestions flowing. :-)

- Arnaldo
