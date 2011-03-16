Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1CPAup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:50:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20727 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1CPAul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pnNmOvQO6yxfFp1seeRZWN5D0ZXiLC7P+/IX5jqmzfiq6mTbRqf3WMnx7FftGNakI5
         7f8g1L4pyZPS9gl5O2ig==
MIME-Version: 1.0
In-Reply-To: <4D7F7121.5040009@librato.com>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <1299869011-26152-7-git-send-email-gthelen@google.com> <4D7F7121.5040009@librato.com>
From: Greg Thelen <gthelen@google.com>
Date: Tue, 15 Mar 2011 17:50:17 -0700
Message-ID: <AANLkTin5tTf4rEuq=UkygQ1=RVQUaGtoX8iPej-kt6Js@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] memcg: add cgroupfs interface to memcg dirty limits
To: Mike Heffner <mike@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>,
        Andrea Righi <arighi@develer.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 7:01 AM, Mike Heffner <mike@librato.com> wrote:
> On 03/11/2011 01:43 PM, Greg Thelen wrote:
>>
>> Add cgroupfs interface to memcg dirty page limits:
>>   Direct write-out is controlled with:
>>   - memory.dirty_ratio
>>   - memory.dirty_limit_in_bytes
>>
>>   Background write-out is controlled with:
>>   - memory.dirty_background_ratio
>>   - memory.dirty_background_limit_bytes
>
>
> What's the overlap, if any, with the current memory limits controlled by
> `memory.limit_in_bytes` and the above `memory.dirty_limit_in_bytes`? If I
> want to fairly balance memory between two cgroups be one a dirty page
> antagonist (dd) and the other an anonymous page (memcache), do I just set
> `memory.limit_in_bytes`? Does this patch simply provide a more granular
> level of control of the dirty limits?
>
>
> Thanks,
>
> Mike
>

The per memcg dirty ratios are more about controlling how memory
within a cgroup is used.  If you isolate two processes in
different memcg, then the memcg dirty ratios will neither help nor hurt
isolation between cgroups.  The per memcg dirty limits are more
focused on providing
some form of better behavior when multiple processes share a single memcg.
Running an antagonist (dd) in the same cgroup as a read-mostly workload
would benefit because the antagonist dirty memory usage should be
capped at the memcg's dirty memory usage.  So any clean page
allocation requests by the read-mostly workload should be faster (and
less likely to OOM) because there will be more clean pages available
within the memcg.
