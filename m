Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1JMETg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:19:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64174 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1JMETf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:19:35 -0400
Date: Wed, 12 Oct 2011 22:19:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <david.daney@cavium.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20111013041931.GH15829@ponder.secretlab.ca>
References: <20110922184614.25419.84606.stgit@ponder>
 <20111011134753.2751aeb1.akpm@linux-foundation.org>
 <4E94B01D.2050402@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E94B01D.2050402@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 02:07:41PM -0700, David Daney wrote:
> On 10/11/2011 01:47 PM, Andrew Morton wrote:
> >On Thu, 22 Sep 2011 12:51:23 -0600
> >Grant Likely<grant.likely@secretlab.ca>  wrote:
> >
> >>Allow drivers to report at probe time that they cannot get all the resources
> >>required by the device, and should be retried at a later time.
> >>
> >>This should completely solve the problem of getting devices
> >>initialized in the right order.  Right now this is mostly handled by
> >>mucking about with initcall ordering which is a complete hack, and
> >>doesn't even remotely handle the case where device drivers are in
> >>modules.  This approach completely sidesteps the issues by allowing
> >>driver registration to occur in any order, and any driver can request
> >>to be retried after a few more other drivers get probed.
> >
> >What happens is there is a circular dependency, or if a driver's
> >preconditions are never met?  AFAICT the code keeps running the probe
> >function for ever.
> >
> 
> The deferred probe functions are only run once per (other) driver
> binding event.  So once you quit registering new drivers, no further
> probing is done.  There is no endless loop happening here.
> 
> If the preconditions are never met, the driver will just sit in the
> list waiting.

Plus, as an optimization, walking the deferred list doesn't begin
until late initcall time so that the first pass over the device
drivers proceeds completely before starting retries.

> >If so: bad.  The kernel should detect such situations, should
> >exhaustively report them and if possible, fix them up and struggle
> >onwards.

The kernel won't get stalled on deferred probe.  It may end up with
stale devices in the deferred list, but that only means those
particular devices won't get bound to a driver.  It isn't fatal.

> I don't think we should actively report anything, but being able to
> inspect the deferred probe list from user space might be useful for
> diagnosing problems

Well, we could dump out the remaining deferred devices in sysfs.
Alternately the kernel could dump them out to the console log after
userspace starts.  That would catch conditions where built-in drivers
aren't able to initialize their devices.

g.
