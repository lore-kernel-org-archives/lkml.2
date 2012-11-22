Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2KVUGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:06:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab2KVUGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:06:36 -0500
Date: Fri, 23 Nov 2012 01:36:18 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211230134410.7814@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
 <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz> <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
 <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz> <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
 <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com> <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz> <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Mon, 19 Nov 2012, Kees Cook wrote --+
| I think to avoid the explosion of request_module calls in the abusive
| case, we could simply return ELOOP instead of ENOEXEC on max
| recursion.

 -> http://www.spinics.net/lists/mm-commits/msg92433.html

1. returning -ELOOP has a side effect of not reaching to request_module()
   ever, for:
==
#ifdef CONFIG_MODULES
1415                 if (retval != -ENOEXEC || bprm->mm == NULL) {
1416                         break;
1417                 } else {
                        ...
==

2. above patch does not seem to fix the 2^6(64) recursions issue, for:
==
+                       bprm->recursion_depth = depth + 1;
                        retval = fn(bprm);
                        bprm->recursion_depth = depth;
==

setting - recursion_dept = depth - again and the outer for(try=0;try<2...) 
loop seems to be causing the 2^6 recursions.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
