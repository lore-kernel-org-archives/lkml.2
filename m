Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2DTVNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:13:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52206 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2DTVNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120420195833.GM6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils> <20120420190418.GK6871@ZenIV.linux.org.uk>
 <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com> <20120420195833.GM6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 14:12:55 -0700
X-Google-Sender-Auth: w-8JyPDLLnKUtG2tKsxY22FQofs
Message-ID: <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:58 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> So does a bunch of other places.  Let me dig out the call graph circa
> 3.3.0...  Here is the relevant part:

Yes, but a lot of those would actually be helped by a helper function
that does all of:
 - grab mmap_sem
 - call do_m[un]map()
 - release mmap_sem

and that would actually clean them up even in the current case.

And then we could do the cleanup in just the helper function.

Not all, no. But a preparatory patch that just creates the helper
functions for doing brk/mmap/munmap would get rid of a fairly big
chunk of them.

You can visualize how many of them do that by just doing

    git grep -5 do_m[un]*map

and then high-lghting '_write(' (to visually show the
down_write/up_write pairs that surround most of them) by searching for
it.

Are they all like that? No. But most of the ones outside of mm/ do fit
that simple pattern and should probably be fixed up just to have them
not contain VM locking details in them *anyway*.

                    Linus
