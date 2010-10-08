Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0JHKU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:20:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34228 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0JHKUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DR7BeDQnaAiF+1BxPK32QG8h7iBJDlIy708VqMEJ1+dpwXkdgw4RZOI05YbFcRGxOD
         KTcT+krd7Z3KHhvNqKhaKBRhugrqv695y6FtAqvDWr1ahSJ/n+xerBlolHdf/UbE/G6b
         kWCYX3Q8TsJriO6Qy7bo9ZZ0S/juflbc9QF7E=
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101008100346.GA27737@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	 <1286515292-15882-16-git-send-email-david@fromorbit.com>
	 <20101008095658.GA19804@ZenIV.linux.org.uk>
	 <20101008100346.GA27737@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:20:19 +0200
Message-ID: <1286533219.2959.128.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 08 octobre 2010 à 06:03 -0400, Christoph Hellwig a écrit :
> On Fri, Oct 08, 2010 at 10:56:58AM +0100, Al Viro wrote:
> > FWIW, that one is begging to be split; what I mean is that there are
> > two classes of callers; ones that will set i_ino themselves anyway
> > and ones that really want i_ino invented.  Two functions?
> 
> There's no reason to add i_ino before adding it to the per-sb list,
> we don't do so either for inodes acquired via iget.  The fix is simply
> to stop assigning i_ino in new_inode and call the helper to get it in
> the place that need it after the call to new_inode.  Later we can
> even move to a lazy assignment scheme where needed.  I'd also really
> like to get a grip on why the simple counters if fine for some
> filesystems while we need iunique() for others.

If iunique() was scalable, sockets could use it, so that we can have
hard guarantee two sockets on machine dont have same inum.

A reasonable compromise here is to use a simple and scalable allocator,
and take the risk two sockets have same inum.

While it might break some applications playing fstats() games, on
sockets, current schem is vastly faster.

I worked with machines with millions of opened socket concurrently,
iunique() was not an option, and application didnt care of possible inum
clash.


For disk files, inum _must_ be unique per fs, for sockets, its only if
you want strict compliance to some standards.



