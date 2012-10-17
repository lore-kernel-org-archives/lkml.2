Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2JQIvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:51:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57857 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2JQIvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <507E4F0C.9040506@cn.fujitsu.com>
References: <507656D1.5020703@jp.fujitsu.com> <50765896.4000300@jp.fujitsu.com>
 <CAHGf_=rvdU+TymYZSXvx1bz4xdp43bqnyjRMGEoiBizC5rP0sQ@mail.gmail.com> <507E4F0C.9040506@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 04:50:40 -0400
X-Google-Sender-Auth: QjemWmkoZDF87AcCUQbhVjvPXvM
Message-ID: <CAHGf_=obXYBGg9HK6d7AyAe7rjM_NyE6icr69aH-DNOp4tB+VA@mail.gmail.com>
Subject: Re: [PATCH 2/2]suppress "Device nodeX does not have a release()
 function" warning
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 2:24 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/12/2012 06:33 AM, KOSAKI Motohiro Wrote:
>> On Thu, Oct 11, 2012 at 1:26 AM, Yasuaki Ishimatsu
>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>> When calling unregister_node(), the function shows following message at
>>> device_release().
>>>
>>> "Device 'node2' does not have a release() function, it is broken and must
>>> be fixed."
>>>
>>> The reason is node's device struct does not have a release() function.
>>>
>>> So the patch registers node_device_release() to the device's release()
>>> function for suppressing the warning message. Additionally, the patch adds
>>> memset() to initialize a node struct into register_node(). Because the node
>>> struct is part of node_devices[] array and it cannot be freed by
>>> node_device_release(). So if system reuses the node struct, it has a garbage.
>>>
>>> CC: David Rientjes <rientjes@google.com>
>>> CC: Jiang Liu <liuj97@gmail.com>
>>> Cc: Minchan Kim <minchan.kim@gmail.com>
>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>> ---
>>>  drivers/base/node.c |   11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> Index: linux-3.6/drivers/base/node.c
>>> ===================================================================
>>> --- linux-3.6.orig/drivers/base/node.c  2012-10-11 10:04:02.149758748 +0900
>>> +++ linux-3.6/drivers/base/node.c       2012-10-11 10:20:34.111806931 +0900
>>> @@ -252,6 +252,14 @@ static inline void hugetlb_register_node
>>>  static inline void hugetlb_unregister_node(struct node *node) {}
>>>  #endif
>>>
>>> +static void node_device_release(struct device *dev)
>>> +{
>>> +#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
>>> +       struct node *node_dev = to_node(dev);
>>> +
>>> +       flush_work(&node_dev->node_work);
>>> +#endif
>>> +}
>>
>> The patch description don't explain why this flush_work() is needed.
>
> If the node is onlined after it is offlined, we will clear the memory,
> so we should flush_work() before node_dev is set to 0.

So then, it is irrelevant from warning supressness. You should make an
another patch.
