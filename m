Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1HXLYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:24:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49064 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab1HXLYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:24:49 -0400
From: "Ravi, Deepthy" <deepthy.ravi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Wed, 24 Aug 2011 16:51:27 +0530
Subject: RE: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Topic: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Index: AcxiRvYdzN4WNecMTxmp0njYwGGb3AACQCUW
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907F6@dbde03.ent.ti.com>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com>,<201108241217.11430.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108241217.11430.laurent.pinchart@ideasonboard.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart
[laurent.pinchart@ideasonboard.com] wrote:
> On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>
>> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
>> option is disabled and if any sensor driver has to be used
>> between MC and non MC framework compatible devices.
>>
>> For example,if tvp514x video decoder driver migrated to
>> MC framework is being built without CONFIG_MEDIA_CONTROLLER
>> option enabled, the following error messages will result.
>> drivers/built-in.o: In function `tvp514x_remove':
>> drivers/media/video/tvp514x.c:1285: undefined reference to
>> `media_entity_cleanup'
>> drivers/built-in.o: In function `tvp514x_probe':
>> drivers/media/video/tvp514x.c:1237: undefined reference to
>> `media_entity_init'
>
> If the tvp514x is migrated to the MC framework, its Kconfig option should
> depend on MEDIA_CONTROLLER.
>The same TVP514x driver is being used for both MC and non MC compatible devices, for example OMAP3 and AM35x. So if it is made dependent on MEDIA CONTROLLER, we cannot enable the driver for MC independent devices.
>> The file containing definitions of media_entity_init and
>> media_entity_cleanup functions will not be built if that
>> config option is disabled. And this is corrected by
>> defining two dummy functions.
>>
>> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
>> ---
>>  include/media/media-entity.h |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index cd8bca6..c90916e 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -121,9 +121,18 @@ struct media_entity_graph {
>>       int top;
>>  };
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>>               struct media_pad *pads, u16 extra_links);
>>  void media_entity_cleanup(struct media_entity *entity);
>> +#else
>> +static inline int media_entity_init(struct media_entity *entity, u16
>> num_pads, +           struct media_pad *pads, u16 extra_links)
>> +{
>> +     return 0;
>> +}
>> +static inline void media_entity_cleanup(struct media_entity *entity) {}
>> +#endif
>>
>>  int media_entity_create_link(struct media_entity *source, u16 source_pad,
>>               struct media_entity *sink, u16 sink_pad, u32 flags);
>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-inf
>