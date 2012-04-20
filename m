Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2DTDPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:15:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2DTDPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:15:12 -0400
Date: Fri, 20 Apr 2012 04:15:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420031509.GE6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420025438.GD6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 03:54:38AM +0100, Al Viro wrote:

> and filp_close() would, if that turns out to be possible, call fput_nodefer()
> instead of fput().  If we *do* have places where we need deferral in
> filp_close() (and I'm fairly sure that any such place is a deadlock right
> now), well, we'll need a variant of filp_close() sans the call of fput...()
> and those places would call that, followed by full (deferring) fput().

BTW, some of those filp_close() are simply wrong - e.g. a big pile in
drivers/media/video/cx25821/*.c should be fput().

And yes, we have at least some under mutex - binder_lock held by
binder_ioctl(), which ends up doing binder_transaction() with its
failure cleanup hitting close_filp().  On an arbitrary struct file.
It *probably* doesn't deadlock on the spot, since binder_release()
itself contains a deferral mechanism (perhaps they'd spotted the
deadlock, perhaps there are other reasons to have it).
