Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab2GDJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:57:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab2GDJ5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:57:22 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336320000"; 
   d="scan'208";a="5328127"
Message-ID: <4FF41484.3070806@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 18:01:40 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC PATCH v2 4/13] memory-hotplug : remove /sys/firmware/memmap/X
 sysfs
References: <4FF287C3.4030901@jp.fujitsu.com> <4FF28996.10702@jp.fujitsu.com> <4FF2929B.7030004@cn.fujitsu.com> <4FF3CA65.1020300@jp.fujitsu.com> <4FF3CFDC.50802@cn.fujitsu.com> <4FF3DA1E.9060505@jp.fujitsu.com>
In-Reply-To: <4FF3DA1E.9060505@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 17:57:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 17:57:22,
	Serialize complete at 2012/07/04 17:57:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/04/2012 01:52 PM, Yasuaki Ishimatsu Wrote:
> Hi Wen,
> 
> 2012/07/04 14:08, Wen Congyang wrote:
>> At 07/04/2012 12:45 PM, Yasuaki Ishimatsu Wrote:
>>> Hi Wen,
>>>
>>> 2012/07/03 15:35, Wen Congyang wrote:
>>>> At 07/03/2012 01:56 PM, Yasuaki Ishimatsu Wrote:
>>>>> When (hot)adding memory into system, /sys/firmware/memmap/X/{end, start, type}
>>>>> sysfs files are created. But there is no code to remove these files. The patch
>>>>> implements the function to remove them.
>>>>>
>>>>> Note : The code does not free firmware_map_entry since there is no way to free
>>>>>          memory which is allocated by bootmem.
>>>>>
>>>>> CC: David Rientjes <rientjes@google.com>
>>>>> CC: Jiang Liu <liuj97@gmail.com>
>>>>> CC: Len Brown <len.brown@intel.com>
>>>>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>>> CC: Paul Mackerras <paulus@samba.org>
>>>>> CC: Christoph Lameter <cl@linux.com>
>>>>> Cc: Minchan Kim <minchan.kim@gmail.com>
>>>>> CC: Andrew Morton <akpm@linux-foundation.org>
>>>>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>>
>>>>> ---
>>>>>    drivers/firmware/memmap.c    |   70 +++++++++++++++++++++++++++++++++++++++++++
>>>>>    include/linux/firmware-map.h |    6 +++
>>>>>    mm/memory_hotplug.c          |    6 +++
>>>>>    3 files changed, 81 insertions(+), 1 deletion(-)
>>>>>
>>>>> Index: linux-3.5-rc4/mm/memory_hotplug.c
>>>>> ===================================================================
>>>>> --- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-07-03 14:22:00.190240794 +0900
>>>>> +++ linux-3.5-rc4/mm/memory_hotplug.c	2012-07-03 14:22:03.549198802 +0900
>>>>> @@ -661,7 +661,11 @@ EXPORT_SYMBOL_GPL(add_memory);
>>>>>
>>>>>    int remove_memory(int nid, u64 start, u64 size)
>>>>>    {
>>>>> -	return -EBUSY;
>>>>> +	lock_memory_hotplug();
>>>>> +	/* remove memmap entry */
>>>>> +	firmware_map_remove(start, start + size - 1, "System RAM");
>>>>> +	unlock_memory_hotplug();
>>>>> +	return 0;
>>>>>
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(remove_memory);
>>>>> Index: linux-3.5-rc4/include/linux/firmware-map.h
>>>>> ===================================================================
>>>>> --- linux-3.5-rc4.orig/include/linux/firmware-map.h	2012-07-03 14:21:45.766421116 +0900
>>>>> +++ linux-3.5-rc4/include/linux/firmware-map.h	2012-07-03 14:22:03.550198789 +0900
>>>>> @@ -25,6 +25,7 @@
>>>>>
>>>>>    int firmware_map_add_early(u64 start, u64 end, const char *type);
>>>>>    int firmware_map_add_hotplug(u64 start, u64 end, const char *type);
>>>>> +int firmware_map_remove(u64 start, u64 end, const char *type);
>>>>>
>>>>>    #else /* CONFIG_FIRMWARE_MEMMAP */
>>>>>
>>>>> @@ -38,6 +39,11 @@ static inline int firmware_map_add_hotpl
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> +static inline int firmware_map_remove(u64 start, u64 end, const char *type)
>>>>> +{
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>    #endif /* CONFIG_FIRMWARE_MEMMAP */
>>>>>
>>>>>    #endif /* _LINUX_FIRMWARE_MAP_H */
>>>>> Index: linux-3.5-rc4/drivers/firmware/memmap.c
>>>>> ===================================================================
>>>>> --- linux-3.5-rc4.orig/drivers/firmware/memmap.c	2012-07-03 14:21:45.761421180 +0900
>>>>> +++ linux-3.5-rc4/drivers/firmware/memmap.c	2012-07-03 14:22:03.569198549 +0900
>>>>> @@ -79,7 +79,16 @@ static const struct sysfs_ops memmap_att
>>>>>    	.show = memmap_attr_show,
>>>>>    };
>>>>>
>>>>> +static void release_firmware_map_entry(struct kobject *kobj)
>>>>> +{
>>>>> +	/*
>>>>> +	 * FIXME : There is no idea.
>>>>> +	 *         How to free the entry which allocated bootmem?
>>>>> +	 */
>>>>
>>>> I find a function free_bootmem(), but I am not sure whether it can work here.
>>>
>>> It cannot work here.
>>>
>>>> Another problem: how to check whether the entry uses bootmem?
>>>
>>> When firmware_map_entry is allocated by kzalloc(), the page has PG_slab.
>>
>> This is not true. In my test, I find the page does not have PG_slab sometimes.
> 
> I think that it depends on the allocated size. firmware_map_entry size is
> smaller than PAGE_SIZE. So the page has PG_Slab.

In my test, I add printk in the function firmware_map_add_hotplug() to display
page's flags. And sometimes the page is not allocated by slab(I use PageSlab()
to verify it).

Thanks
Wen Congyang

> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>
>> Thanks
>> Wen Congyang.
>>
>>> So we can check whether the entry was allocated by bootmem or not.
>>> If the eantry was allocated by kzalloc(), we can free the entry by kfree().
>>> But if the entry was allocated by bootmem, we have no way to free the entry.
>>>
>>> Thanks,
>>> Yasuaki Ishimatsu
>>>
>>>>
>>>> Thanks
>>>> Wen Congyang
>>>>
>>>>> +}
>>>>> +
>>>>>    static struct kobj_type memmap_ktype = {
>>>>> +	.release	= release_firmware_map_entry,
>>>>>    	.sysfs_ops	= &memmap_attr_ops,
>>>>>    	.default_attrs	= def_attrs,
>>>>>    };
>>>>> @@ -123,6 +132,16 @@ static int firmware_map_add_entry(u64 st
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> +/**
>>>>> + * firmware_map_remove_entry() - Does the real work to remove a firmware
>>>>> + * memmap entry.
>>>>> + * @entry: removed entry.
>>>>> + **/
>>>>> +static inline void firmware_map_remove_entry(struct firmware_map_entry *entry)
>>>>> +{
>>>>> +	list_del(&entry->list);
>>>>> +}
>>>>> +
>>>>>    /*
>>>>>     * Add memmap entry on sysfs
>>>>>     */
>>>>> @@ -144,6 +163,31 @@ static int add_sysfs_fw_map_entry(struct
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> +/*
>>>>> + * Remove memmap entry on sysfs
>>>>> + */
>>>>> +static inline void remove_sysfs_fw_map_entry(struct firmware_map_entry *entry)
>>>>> +{
>>>>> +	kobject_put(&entry->kobj);
>>>>> +}
>>>>> +
>>>>> +/*
>>>>> + * Search memmap entry
>>>>> + */
>>>>> +
>>>>> +struct firmware_map_entry * __meminit
>>>>> +find_firmware_map_entry(u64 start, u64 end, const char *type)
>>>>> +{
>>>>> +	struct firmware_map_entry *entry;
>>>>> +
>>>>> +	list_for_each_entry(entry, &map_entries, list)
>>>>> +		if ((entry->start == start) && (entry->end == end) &&
>>>>> +		    (!strcmp(entry->type, type)))
>>>>> +			return entry;
>>>>> +
>>>>> +	return NULL;
>>>>> +}
>>>>> +
>>>>>    /**
>>>>>     * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
>>>>>     * memory hotplug.
>>>>> @@ -196,6 +240,32 @@ int __init firmware_map_add_early(u64 st
>>>>>    	return firmware_map_add_entry(start, end, type, entry);
>>>>>    }
>>>>>
>>>>> +/**
>>>>> + * firmware_map_remove() - remove a firmware mapping entry
>>>>> + * @start: Start of the memory range.
>>>>> + * @end:   End of the memory range (inclusive).
>>>>> + * @type:  Type of the memory range.
>>>>> + *
>>>>> + * removes a firmware mapping entry.
>>>>> + *
>>>>> + * Returns 0 on success, or -EINVAL if no entry.
>>>>> + **/
>>>>> +int __meminit firmware_map_remove(u64 start, u64 end, const char *type)
>>>>> +{
>>>>> +	struct firmware_map_entry *entry;
>>>>> +
>>>>> +	entry = find_firmware_map_entry(start, end, type);
>>>>> +	if (!entry)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	/* remove the memmap entry */
>>>>> +	remove_sysfs_fw_map_entry(entry);
>>>>> +
>>>>> +	firmware_map_remove_entry(entry);
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>    /*
>>>>>     * Sysfs functions -------------------------------------------------------------
>>>>>     */
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 
> 

