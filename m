Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2DPMK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:10:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab2DPMKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:10:25 -0400
Message-ID: <4F8C0C2F.7020306@suse.de>
Date: Mon, 16 Apr 2012 14:10:23 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] driver core: check 'start' argument in bus iterators
References: <1334573285-24016-1-git-send-email-hare@suse.de> <CAPXgP11S6R4L-8tZ4cPY=MZfcvTBBHkUdTvt7FTKhvhVF6uKPQ@mail.gmail.com>
In-Reply-To: <CAPXgP11S6R4L-8tZ4cPY=MZfcvTBBHkUdTvt7FTKhvhVF6uKPQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 01:51 PM, Kay Sievers wrote:
> On Mon, Apr 16, 2012 at 12:48, Hannes Reinecke <hare@suse.de> wrote:
>> bus_for_each_dev() and bus_find_device() both take a 'start'
>> argument to start the iteration at a specific list entry.
>> However, this list entry might already been detached by
>> the time these functions are called.
>> So we need to check if the arguments are still valid.
> 
>> +       if (start && !klist_node_attached(&start->p->knode_bus))
>> +               return -ENODEV;
>> +
>>        klist_iter_init_node(&bus->p->klist_devices, &i,
>>                             (start ? &start->p->knode_bus : NULL));
> 
> Shouldn't we do this check in klist_iter_init_node()?
> After a kref_get(), and return -ENODEV from there if the node it as
> asked to start is gone?
> 
Sure, if you prefer.

> This check otherwise still has the window between the check and the
> use of it, only very unlikely to hit now, hasn't it?
> 
yeah, very.
The iteration itself could take some time (locks etc), but the race
between those two lines is really tiny.

But yeah, for the sake of correctness, we should.

I'll be sending an updated patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
