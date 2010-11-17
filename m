Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab0KQKKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:10:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60281 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932951Ab0KQKKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:10:12 -0500
Message-ID: <4CE3AA37.8060709@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 18:11:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: viro@zeniv.linux.org.uk, Chris Mason <chris.mason@oracle.com>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ito <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] direct-io: add a hook for the fs to provide its	own
 bio merging check function
References: <4CE3579B.1000301@cn.fujitsu.com> <20101117070658.GF5618@dhcp231-156.rdu.redhat.com> <20101117093720.GG5618@dhcp231-156.rdu.redhat.com>
In-Reply-To: <20101117093720.GG5618@dhcp231-156.rdu.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 18:10:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 18:10:32,
	Serialize complete at 2010-11-17 18:10:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Josef

On wed, 17 Nov 2010 04:37:21 -0500, Josef Bacik wrote:
>> Heh so I was going to fix this after the hole punching stuff.  The fact is btrfs
>> maps everything that is ok to do in one IO via get_blocks().  So all we need to
>> do is add another DIO_ flag to tell us to treat each get_blocks() call as
>> discrete.  I wanted to use buffer_boundary for this, but I think it's too
>> drastic of a change for people who already use buffer_boundary();
>>
>> What happens today is that say we map 4k, we do submit_page_section, but if this
>> is our first bit of IO we just set dio->cur_page and such and then loop again.
>> Say there is 4k-hole-4k, we do the next mapping and set buffer_boundary again,
>> and come into submit_page_section and because cur_page is set, we do
>> dio_send_cur_page.  Because there is no dio->bio we setup a new bio, but when we
>> do that we clear dio->boundary, and leave the bio all setup.  So the next time
>> we loop around the tail 4k gets added to our previously setup bio and boom we
>> hit this problem with btrfs.
>>
>> If we can add a DIO_GET_BLOCKS_DISCRETE or some other such non-sense then we can
>> easily kill all the logical offset code I had and just make some simple changes
>> to make the DIO stuff work for us.  All we do is in get_more_blocks we do
>>
>> if ((dio->flags&  DIO_GET_BLOCKS_DISCRETE)&&  dio->bio)
>> 	dio_submit_bio(dio);
>>
>
> Right after I went to bed I realized this should be
>
> if (dio->flags&  DIO_GET_BLOCKS_DISCRETE) {
> 	if (dio->cur_page) {
> 		dio_send_cur_page(dio);
> 		page_cache_release(dio->cur_page);
> 		dio->cur_page = NULL;
> 	}
>
> 	if (dio->bio)
> 		dio_submit_bio(dio);
>   }

As far as I know, get_block() can not make sure the IO doesn't span the chunks or
stripes. Maybe we can do this check in get_blocks(). In this way, we needn't change
vfs.

I have written the patch and is testing it now. Up to now, it works well.

Thanks
Miao
