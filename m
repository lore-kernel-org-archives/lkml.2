Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1ELSkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:40:52 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:60821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1ELSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:40:51 -0400
Subject: Re: [PATCH v2] net: rfkill: add generic gpio rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Rhyland Klein <rklein@nvidia.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305224592.10961.10.camel@rklein-linux2>
References: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
	 <1305189092.3461.10.camel@jlt3.sipsolutions.net>
	 <1305224592.10961.10.camel@rklein-linux2>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 20:40:48 +0200
Message-ID: <1305225648.3461.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 11:23 -0700, Rhyland Klein wrote:

> > Are you sure starting out with UNSPECIFIED works? Then you'll always
> > change, but if the clock was enabled already you still enable it on the
> > first set_block() from rfkill, which still has the refcount problem, no?
> > It seems to me that the original state has to be passed in from the
> > platform?

> I thought about that. But I decided the clock that it is possible to
> have the clock used for the radio used for something else right? 

Sure.

> in
> which case, the driver will leave the clk in whatever state it initially
> finds it. I.e. if the clock is disabled, then it will enable it only
> once and work, if it is enabled, it will add a refcount (only once) and
> then work and disable it again only once. It never changes the refcount
> in either direction by more than 1, and this way the initial setting of
> the clock is irrelevant. The board files can simply initialize the block
> as off if that is the initial clk state they want.

The issue is that depending on how you boot, the first refcount change
might be +1 or it might be -1.

If rfkill decides that at the time of loading wifi should be off, then
the first change would be -1, and after that it would flip between 0 and
-1.

If, on the other hand, rfkill decides that at the time of loading the
driver wifi should be on, then the first change would be +1 and it'll
flip between 0 and +1.

This seems like it'll cause issues at some point, so I think you should
either allow the driver to set the initial state or hardcode one of
these possibilities (so at least it's predictable)

johannes

