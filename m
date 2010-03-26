Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0CZEtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:49:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:40404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0CZEto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:49:44 -0400
Message-ID: <4BAC3CE0.2010408@suse.de>
Date: Fri, 26 Mar 2010 13:49:36 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
References: <20100324031829.2136.66489.stgit@notabene.brown>
In-Reply-To: <20100324031829.2136.66489.stgit@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/24/2010 12:20 PM, NeilBrown wrote:
> This series tidies up the refcount of sysfs_dirents in sysfs,
> using kref where appropriate and a new karef for s_active.
> This achieves significant code simplification, especially the first
> patch.
> 
> This is in part inspired by http://lwn.net/Articles/336224/ :-)

Nice article.  In general, yeap, I agree it would be nice to have a
working reference count abstraction.  However, kref along with kobject
is a good example of obscurity by abstraction anti pattern.  :-)

kobject API incorrectly suggests that it deals with the last put
problem.  There still are large number of code paths which do the
following,

  if (!(kob = kobject_get(kobj)))
	return;

I believe (or at least hope) the actual problem cases are mostly fixed
now but there still are a lot of misconceptions around how stuff built
on kref/kobject is synchronized and they sometimes lead to race
conditions buried deep under several layers of abstractions and it
becomes very hard to see those race conditions when they are buried
deep.

If you want to kill refcounts w/ bias based off switch, please put it
inside an abstraction which at least synchronizes itself properly.
Open coding w/ bias at least warns you that there is some complex
stuff going on and you need to trade carefully.  Putting the switch on
a separate flag - people often forget how bits in a flag field are
synchronized - and the rest of refcount in a nice looking kref bundle
is very likely to lead to subtle race conditions which are *very*
difficult to notice.

Thanks.

-- 
tejun
