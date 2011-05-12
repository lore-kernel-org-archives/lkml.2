Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1ELAMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:12:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51102 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1ELAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:12:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Don't understand comment in arch/x86/boot/compressed/misc.c
References: <4DCB1044.6030505@landley.net>
Date: Wed, 11 May 2011 17:12:02 -0700
In-Reply-To: <4DCB1044.6030505@landley.net> (Rob Landley's message of "Wed, 11
	May 2011 17:40:04 -0500")
Message-ID: <m1wrhwixpp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18upAO711OhH1hZQ44vqqqKzpuRF0qN9/c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> It talks about when decompression in place is safe to do:
>
>  * Getting to provable safe in place decompression is hard.
>  * Worst case behaviours need to be analyzed.
> ...
>  * The buffer for decompression in place is the length of the
>  * uncompressed data, plus a small amount extra to keep the algorithm safe.
>  * The compressed data is placed at the end of the buffer.  The output
>  * pointer is placed at the start of the buffer and the input pointer
>  * is placed where the compressed data starts.  Problems will occur
>  * when the output pointer overruns the input pointer.
>  *
>  * The output pointer can only overrun the input pointer if the input
>  * pointer is moving faster than the output pointer.  A condition only
>  * triggered by data whose compressed form is larger than the uncompressed
>  * form.
>
> You have an output pointer at a lower address catching up to an input
> pointer at a higher address.  If the input pointer is moving FASTER
> than the output pointer, wouldn't the gap between them grow rather
> than shrink?

The wording might be clearer but the basic concept in context seems
fine.  The entire section is talking about how many bytes more than the
uncompressed size of the data do you need to guarantee you won't overrun
your compressed data.

For gzip that is a smidge over a single compressed block.

In the worst case you have to assume that none of your blocks
actually compressed.

So an input pointer going faster than an output pointer is a problem
if you try to limit yourself to exactly the area of memory that the
decompressed data lives in.  In that case the input point will
run off the end.

> The concern seems to be about COMPRESSING in place, rather than
> decompressing...?

No.  In theory there is some data that when compressed will grow.  In
the best case that data will grow only by a single bit.

In case a picture will help.

  Decompressed data goes here       Compressed data comes from here
  |                                 |
0 v->                               v->
+---------------------------------------+-----+------------+
|                                       |extra|decompressor|
+---------------------------------------+-----+------------+

The question is how large that extra chunk needs to be.  This matters
either when nothing compresses (the worst case for extra space) or
especially when you get a chunk of blocks at the end that don't
compress (a plausible but almost worst case scenario).

Things have changed a bit since I wrote that analysis.  The computation
of the worst case space has moved to mkpiggy.c, support for other
compression methods have been added, and we now have a mini ELF loader
in misc.c which adds an extra step to everything.  But the overall
concepts remain valid.

Eric
