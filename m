Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2FHA0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:26:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab2FHAZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com>
References: <20120607212114.E4F5AA02F8@akpm.mtv.corp.google.com> <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 17:25:34 -0700
X-Google-Sender-Auth: 7niTGYInoy2lfbboguVnLgM8ZT0
Message-ID: <CA+55aFyQUBXhjVLJH6Fhz9xnpfXZ=9Mej5ujt6ss7VUqT1g9Jg@mail.gmail.com>
Subject: Re: [patch 12/12] mm: correctly synchronize rss-counters at exit/exec
To: akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        markus@trippelsdorf.de, oleg@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, looking more at the patch, I'm getting more and more convinces
that it is pure and utter garbage.

It does "sync_mm_rss(mm);" in mmput(), _after_ it has done the
possibly final mmdrop(). WTF?

This is crap, guys. Seriously. Stop playing russian rulette with this
code. I think we need to revert *all* of the crazy rss games, unless
Konstantin can show us some truly obviously correct fix.

Sadly, I merged and pushed out the crap before I had rebooted and
noticed this problem, so now it's in the wild. Can somebody please
take a look at this asap?

             Linus

On Thu, Jun 7, 2012 at 5:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This patch actually seems to have made the
>
>  BUG: Bad rss-counter state ..
>
> problem *much* worse. It triggers all the time for me now - I've got
> 408 of those messages on my macbook air within a minute of booting it.
>
> Not good. Especially not good when it's marked for stable too.
