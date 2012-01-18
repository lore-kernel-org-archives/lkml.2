Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2ARTHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:07:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab2ARTHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:07:40 -0500
Message-ID: <4F171873.9040308@kernel.dk>
Date: Wed, 18 Jan 2012 20:07:31 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        koverstreet@google.com, Neil Brown <neilb@suse.de>
Subject: Re: Kernel crash in icq_free_icq_rcu
References: <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com> <20120118011112.GB32160@htj.dyndns.org> <1326850253.22361.619.camel@sli10-conroe> <1326866602.22361.624.camel@sli10-conroe> <20120118135126.GB30204@redhat.com> <20120118142005.GC30204@redhat.com> <20120118160957.GB30664@google.com> <4F16F245.9000708@kernel.dk> <4F16F3CA.90904@kernel.dk> <20120118163638.GD30204@redhat.com> <20120118171029.GD30664@google.com>
In-Reply-To: <20120118171029.GD30664@google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-18 18:10, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Wed, Jan 18, 2012 at 11:36:38AM -0500, Vivek Goyal wrote:
>> Not calling ioscheduler during plug merge will allow merging of sync/async
>> requests together. I guess we wouldn't want that. The only check we can
>> skip in case of plug merge, is whether bio and rq beong to same task/cfqq
>> or not.
>>
>> May be separate elevator functions for plug merge (without lock) and
>> elevator merge (with lock) will do?
> 
> I don't think so.  As I wrote before, plugging is about issuing, not
> scheduling.  In a sense, it's a block layer service to upper layers to
> make building larger request easier such that block layer users can do
> "plug - issue multiple bios of whatever size - flush" instead of
> having to manually build series of maximum sized bios.  As such, bios
> submitted during a single plugging fare naturally expected to be for
> the same purpose.  They all belong to single IO unit after all.
> 
> Note that although request is involved in plug merging, the request
> isn't known to elevator (other than set_request(), that is).  The only
> reason we go half-way through request issuing, stash request, do plug
> merging and then do the rest on flush is because block layer doesn't
> have a way to deal with arbitrarily sized bios.  We're piggy backing
> on request merge logic because that's the only way we know how to
> group bios.
> 
> In the long run, I think plugging should be done with bios.  There's
> no reason to care about requests at that level.  We're just collecting
> bios issued as a unit and are likely to be close to each other.  If
> request_queue can deal with arbitrarily sized bios (and list of them),
> we can simply collect bios and flush down on unplug.  This would be
> much cleaner, make plugging useable for bio based drivers and allow
> simplifying stacking drivers.

In the longer term, plugging and merging should be much less needed.
Most file systems should have done this upfront already, so the need for
it should be much smaller. For the eventual multiqueue setup, I don't
plan on doing much work around merging at all. Perhaps some basic
merging for when it hits the final queue, but not at submit time.

-- 
Jens Axboe

