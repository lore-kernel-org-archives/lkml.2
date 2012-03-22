Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab2CVOWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:22:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2CVOWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:22:20 -0400
Date: Thu, 22 Mar 2012 14:22:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
Message-ID: <20120322142212.GV6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 02:54:15PM -0400, Mimi Zohar wrote:
> If a file is closed before it is munmapped, __fput() is called with
> the mmap_sem taken.  With IMA-appraisal enabled, this results in an
> mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count
> to defer __fput() being called until after the mmap_sem is released.

NAK.  It's far too heavy-weight for what's a very common path.  Worse,
it causes different locking conditions on IMA and non-IMA kernels and makes
bugs harder to spot.  Rejected with extreme prejudice; please, fix your
locking instead.

BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
be enough to paper over your problem anyway.

Final fput() *can* happen under mmap_sem.  Period.
