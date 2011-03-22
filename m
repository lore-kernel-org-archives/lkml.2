Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1CVPmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:42:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35107 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1CVPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v+iNb3p2DqiYlqP05Fxl6teB/DP/J8/5FE1xSeUP6MtVd6Ty8AtFqKl2vL2OukHfMQ
         B2DBApYDKirS5SobT8OVQpRI+yhTD6T+j+nUnPDGbmeZeP1YLW6mUFTgi9G3TJ2VRGCH
         116SR8u3hyzNZD72/XQwo0Cma4RN/9d66c9JM=
Date: Tue, 22 Mar 2011 08:42:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: tsc2005: fix locking issue
Message-ID: <20110322154202.GA24772@core.coreip.homeip.net>
References: <1300724650-6641-1-git-send-email-aaro.koskinen@nokia.com>
 <20110322061958.GA7990@core.coreip.homeip.net>
 <alpine.DEB.1.10.1103221655370.2634@esdhcp041196.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1103221655370.2634@esdhcp041196.research.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:59:02PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Mon, 21 Mar 2011, Dmitry Torokhov wrote:
> >On Mon, Mar 21, 2011 at 06:24:10PM +0200, Aaro Koskinen wrote:
> >>Commit 0b950d3 (Input: tsc2005 - add open/close) introduced a
> >>locking issue with the ESD watchdog: __tsc2005_disable() is calling
> >>cancel_delayed_work_sync() with mutex held, and the work also needs the
> >>same mutex.
> >>
> >>Fix the problem by using cancel_delayed_work() on disable. If
> >>the ESD work was running it will check if the device is closed
> >>or suspended, and in that case it will do nothing and skip
> >>re-arming. cancel_delayed_work_sync() is still needed when the module
> >>is removed.
> >
> >Hmm, indeed. However, instead of moving cancel_delayed_work_sync() to
> >remove maybe we should use mutex_trylock() in tsc2005_esd_work()?
> >If trylock fails that means that device is in the middle of open/close
> >transition. We should just reschedule the work and get out of there.
> 
> But I guess the reschedule should not happen if we are in the middle of
> close/disable? And without the mutex we cannot know that.

It should be OK to reschedule even as we enabling/disabling because
cancel_delayed_work_sync() handles re-arming works so even if ESD work
is being executed at the time we closing the device it will be killed
off completely.

Thanks.

-- 
Dmitry
