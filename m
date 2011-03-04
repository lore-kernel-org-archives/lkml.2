Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab1CDAas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:30:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab1CDAar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:30:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XQKnnPWB5TEmbFVAA6J5pWjMmu6RnbeR9rWXGtrEuxC885qrMVVFMxB2HTf7+4h2RA
         oenw7NozHhP/nkMFjvDA==
MIME-Version: 1.0
In-Reply-To: <20110302231727.GG2547@redhat.com>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
 <1298669760-26344-10-git-send-email-gthelen@google.com> <20110302231727.GG2547@redhat.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 3 Mar 2011 16:30:23 -0800
Message-ID: <AANLkTinSrmH-XGuFMBve9SczdXsmKzJbFN4cZ234=z9A@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] memcg: check memcg dirty limits in page writeback
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 3:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Feb 25, 2011 at 01:36:00PM -0800, Greg Thelen wrote:
>
> [..]
>> @@ -500,18 +527,27 @@ static void balance_dirty_pages(struct address_space *mapping,
>>               };
>>
>>               global_dirty_info(&sys_info);
>> +             if (!memcg_dirty_info(NULL, &memcg_info))
>> +                     memcg_info = sys_info;
>>
>>               /*
>>                * Throttle it only when the background writeback cannot
>>                * catch-up. This avoids (excessively) small writeouts
>>                * when the bdi limits are ramping up.
>>                */
>> -             if (dirty_info_reclaimable(&sys_info) + sys_info.nr_writeback <=
>> +             if ((dirty_info_reclaimable(&sys_info) +
>> +                  sys_info.nr_writeback <=
>>                               (sys_info.background_thresh +
>> -                              sys_info.dirty_thresh) / 2)
>> +                              sys_info.dirty_thresh) / 2) &&
>> +                 (dirty_info_reclaimable(&memcg_info) +
>> +                  memcg_info.nr_writeback <=
>> +                             (memcg_info.background_thresh +
>> +                              memcg_info.dirty_thresh) / 2))
>>                       break;
>>
>> -             bdi_thresh = bdi_dirty_limit(bdi, sys_info.dirty_thresh);
>> +             bdi_thresh = bdi_dirty_limit(bdi,
>> +                             min(sys_info.dirty_thresh,
>> +                                 memcg_info.dirty_thresh));
>>               bdi_thresh = task_dirty_limit(current, bdi_thresh);
>
> Greg, so currently we seem to have per_bdi/per_task dirty limits and
> now with this patch it will sort of become per_cgroup/per_bdi/per_task
> dirty limits? I think that kind of makes sense to me.
>
> Thanks
> Vivek
>

Vivek,  you are correct.  This patch adds per_cgroup limits to the
existing system, bdi, and system dirty memory limits.
