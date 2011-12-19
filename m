Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1LSTFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:05:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52719 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LSTFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:05:13 -0500
Date: Mon, 19 Dec 2011 11:05:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, John Stultz <john.stultz@linaro.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Android low memory killer vs. memory pressure notifications
In-Reply-To: <20111219074843.GA21324@barrios-laptop.redhat.com>
Message-ID: <alpine.DEB.2.00.1112191059010.19949@chino.kir.corp.google.com>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219074843.GA21324@barrios-laptop.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Minchan Kim wrote:

> Kernel should have just signal role when resource is not enough.
> It is desirable that killing is role of user space.

The low memory killer becomes an out of memory killer very quickly if 
(1) userspace can't respond fast enough and (2) the killed thread cannot 
exit and free its memory fast enough.  It also requires userspace to know 
which threads are sharing memory such that they may all be killed; 
otherwise, killing one thread won't lead to future memory freeing.

If the system becomes oom before userspace can kill a thread, then there's 
no guarantee that it will ever be able to exit.  That's fixed in the 
kernel oom killer by allowing special access to memory reserves 
specifically for this purpose, which userspace can't provide.

So the prerequisites for this to work correctly every time would be to 
ensure that points (1) and (2) above can always happen.  I'm not seeing 
where that's proven, so presumably you'd still always need the kernel oom 
killer.
