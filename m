Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2AQVFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:05:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49456 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2AQVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:05:31 -0500
Message-ID: <4F15E294.2000806@gmail.com>
Date: Tue, 17 Jan 2012 22:05:24 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/8] media: video: introduce object detection driver
 module
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>	<1323871214-25435-8-git-send-email-ming.lei@canonical.com>	<4EFCA06C.7050307@gmail.com> <CACVXFVPqntLKoyLxY2xeya3mZx_1vh-QQQCp=N2-vC9tooKwOA@mail.gmail.com>
In-Reply-To: <CACVXFVPqntLKoyLxY2xeya3mZx_1vh-QQQCp=N2-vC9tooKwOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 09:13 AM, Ming Lei wrote:
>>> +
>>> +int odif_open(struct file *file)
>>> +{
>>> +     struct odif_dev *dev = video_drvdata(file);
>>> +
>>> +     kref_get(&dev->ref);
>>> +     return v4l2_fh_open(file);
>>> +}
>>
>> Individual drivers may need to perform some initialization when
>> device node is opened. So I consider taking this possibility away
>> from them not a good idea.
> 
> OK, it can be handled easily by introducing new callbacks(such as.
> .open_detect and .close_detect for close) in struct odif_ops.

Certainly, we can introduce plenty of new callbacks, another levels of 
indirection that would just obfuscate things. It should rather be done 
like v4l2-mem2mem does, where file operation handlers are implemented 
by each driver and from their open()/close() handlers relevant init
and release functions are called (v4l2_m2m_init/v4l2_m2m_release).

I think we can always change the kernel interfaces once there is more 
devices like OMAP4 FDIF. It may look easy for you when you refer to 
just one hardware implementation with your theoretically generic module. 
Or have you referred to other devices than OMAP4 FDIF when designing it ?

>>> +static int vidioc_g_od_result(struct file *file, void *priv,
>>> +                                     struct v4l2_od_result *f)
>>> +{
>>> +     struct odif_dev *dev = video_drvdata(file);
>>> +     unsigned long flags;
>>> +     struct v4l2_odif_result *tmp;
>>> +     struct v4l2_odif_result *fr = NULL;
>>> +     unsigned int cnt = 0;
>>> +     int ret = -EINVAL;
>>> +
>>> +     spin_lock_irqsave(&dev->lock, flags);
>>> +     list_for_each_entry(tmp,&dev->odif_dq.complete, list)
>>> +             if (tmp->frm_seq == f->frm_seq) {
>>> +                     fr = tmp;
>>> +                     list_del(&tmp->list);
>>> +                     break;
>>> +             }
>>> +     spin_unlock_irqrestore(&dev->lock, flags);
>>> +
>>> +     if (fr) {
>>> +             ret = 0;
>>> +             cnt = min(f->obj_cnt, fr->obj_cnt);
>>> +             if (cnt)
>>> +                     memcpy(f->od, fr->objs,
>>> +                             sizeof(struct v4l2_od_object) * cnt);
>>> +             f->obj_cnt = cnt;
>>> +
>>> +             free_result(fr);
>>
>> Some drivers may be designed so they do not discard the result data
>> automatically once it is read by user application. AFAICS this module
>> doesn't allow such behaviour.
>>
>> For instance, it might be required to discard the oldest results data
>> when the ring buffer gets filled in.
> 
> Looks like no any benefit about keeping the old result data, could you
> give some use cases which require the old results need to be kept for
> some time?

Consider scenario where one thread writes image data and multiple threads
read the FD results. Having all data discarded on first read only one 
thread could get the data. This is not what we want in a standard API.

Also in V4L2 it is always assumed that multiple applications can read
state of a device, and the application priority API [1] aims at
managing the devices state modifications among multiple processes.
 ...
>>> +static int buffer_init(struct vb2_buffer *vb)
>>> +{
>>> +     struct odif_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
>>> +
>>> +     /*
>>> +      * This callback is called once per buffer, after its allocation.
>>> +      *
>>> +      * Vivi does not allow changing format during streaming, but it is
>>> +      * possible to do so when streaming is paused (i.e. in streamoff state).
>>> +      * Buffers however are not freed when going into streamoff and so
>>> +      * buffer size verification has to be done in buffer_prepare, on each
>>> +      * qbuf.
>>> +      * It would be best to move verification code here to buf_init and
>>> +      * s_fmt though.
>>> +      */
>>> +     dprintk(dev, 1, "%s vaddr=%p\n", __func__,
>>> +                     vb2_plane_vaddr(vb, 0));
>>> +
>>> +     return 0;
>>> +}
>>
>> As I already mentioned this empty callback can be removed. Anyway IMO the
>> implementation of the buffer queue operations should be left to individual
>> drivers. Having them in generic module doesn't sound flexible enough.
> 
> IMO, the buffer queue operations can be shared for use case of
> detecting objects from user space images, so it may be kept it in
> generic driver.

Not necessarily, sometimes device specific logic needs to be implemented
in these callbacks. And the ioctl handlers (vidioc_*) should be just 
pass-through for the vb2 callbacks.

>>
>>> +void odif_add_detection(struct odif_dev *dev,
>>> +             struct v4l2_odif_result *v4l2_fr)
>>> +{
>>> +     unsigned long flags;
>>> +     struct v4l2_odif_result *old = NULL;
>>> +     struct v4l2_odif_result *tmp;
>>> +
>>> +     spin_lock_irqsave(&dev->lock, flags);
>>> +     list_for_each_entry(tmp,&dev->odif_dq.complete, list)
>>> +             if (tmp->frm_seq == v4l2_fr->frm_seq) {
>>> +                     old = tmp;
>>> +                     list_del(&tmp->list);
>>> +                     break;
>>> +             }
>>> +     list_add_tail(&v4l2_fr->list,&dev->odif_dq.complete);
>>> +     spin_unlock_irqrestore(&dev->lock, flags);
>>> +
>>> +     if (old)
>>> +             free_result(old);
>>> +     else
>>> +             atomic_inc(&dev->odif_dq.complete_cnt);
>>> +}
>>> +EXPORT_SYMBOL_GPL(odif_add_detection);
>>> +
>>> +struct v4l2_odif_result *odif_allocate_detection(struct odif_dev *dev,
>>> +             int cnt)
>>> +{
>>> +     struct v4l2_odif_result *result = NULL;
>>> +     unsigned long flags;
>>> +
>>> +     if (atomic_read(&dev->odif_dq.complete_cnt)>=
>>> +                     result_cnt_threshold) {
>>> +             spin_lock_irqsave(&dev->lock, flags);
>>> +             result = list_entry(dev->odif_dq.complete.next,
>>> +                                     struct v4l2_odif_result, list);
>>> +             list_del(&result->list);
>>> +             spin_unlock_irqrestore(&dev->lock, flags);
>>> +
>>> +             atomic_dec(&dev->odif_dq.complete_cnt);
>>> +     }
>>> +
>>> +     if (!result)    goto allocate_result;
>>> +
>>> +     /* reuse the old one if count is matched */
>>> +     if (result->obj_cnt == cnt)
>>> +             goto out;
>>> +
>>> +     /*free the old result*/
>>> +     free_result(result);
>>> +
>>> +allocate_result:
>>> +     result = kzalloc(sizeof(*result) +
>>> +                     cnt * sizeof(struct v4l2_od_object), GFP_ATOMIC);
>>
>> I prefer not allocating memory in interrupt context like this, especially
>> as this can be avoided without significant effort and resources waste.
> 
> Considered that the allocated space is not very large, maybe it can be allocated
> in interrupt context. The count of v4l2_od_object to be allocated is variant,
> so it is not easy to reserve buffers during driver init to handle variant buffer
> allocation.  Also this can be left for future optimization.

Right. This is a policy decision that this module makes for all future drivers
that would use it. Some hardware also allows to limit number of detected faces,
making it easy to allocate in advance the result data buffers.

...
>>> +static int odif_init_entities(struct odif_dev *odif)
>>> +{
>>> +     const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_DYNAMIC;
>>> +     int ret;
>>> +     struct odif_entity *entity;
>>> +     struct media_entity *source;
>>> +     struct media_entity *sink;
>>> +
>>> +     /*entity[0] is the entity for object detection hw*/
>>> +     entity =&odif->entity[0];
>>> +     entity->num_links = 2;
>>> +     entity->num_pads = 1;
>>> +     entity->pads[0].flags = MEDIA_PAD_FL_SINK;
>>> +
>>> +     v4l2_subdev_init(&entity->subdev,&odif_subdev_ops);
>>> +     v4l2_set_subdevdata(&entity->subdev, odif);
>>> +     strlcpy(entity->subdev.name, "object detect",
>>> +                     sizeof(entity->subdev.name));
>>> +     ret = media_entity_init(&entity->subdev.entity,
>>> +             entity->num_pads, entity->pads, 1);
>>> +
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     /*entity[1] is the video entity which sources the user space video*/
>>> +     entity =&odif->entity[1];
>>> +     entity->num_links = 1;
>>> +     entity->num_pads = 1;
>>> +     entity->pads[0].flags = MEDIA_PAD_FL_SOURCE;
>>> +
>>> +     v4l2_subdev_init(&entity->subdev,&odif_subdev_ops);
>>> +     v4l2_set_subdevdata(&entity->subdev, odif);
>>> +     strlcpy(entity->subdev.name, "user space video",
>>> +                     sizeof(entity->subdev.name));
>>> +     ret = media_entity_init(&entity->subdev.entity,
>>> +             entity->num_pads, entity->pads, 0);
>>> +
>>> +     /* create the default link */
>>> +     source =&odif->entity[1].subdev.entity;
>>> +     sink =&odif->entity[0].subdev.entity;
>>> +     sink->ops =&odif_entity_ops;
>>> +     ret = media_entity_create_link(source, 0,
>>> +                                    sink, 0, flags);
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     /* init the default hw link*/
>>> +     if (odif->ops->set_input)
>>> +             ret = odif->ops->set_input(odif,
>>> +                     OD_INPUT_FROM_USER_SPACE,
>>> +&odif->entity[1].pads[0]);
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     odif->input = OD_INPUT_FROM_USER_SPACE;
>>> +
>>> +     /* register the two subdevices */
>>> +     ret = v4l2_device_register_subdev(&odif->v4l2_dev,
>>> +&odif->entity[0].subdev);
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     ret = v4l2_device_register_subdev(&odif->v4l2_dev,
>>> +&odif->entity[1].subdev);
>>
>> You're creating v4l2 subdevice but not all drivers would require it.
>> Also individual drivers will usually manage connections between the media
>> entities on their own. So IMHO this module goes a little to far on fixing
>> up driver's architecture.
>>
>> Also what are there two subdevs needed for ?
> 
> The two subsevs are used to describe two media entity, one of which
> is the object detection hw, and another is the video entity which sources
> the user space video. Without the two entities, I don't know how media
> controller connects these into framework.

The video device also represents a media entity. You would just have to
embed a media pad in the video device driver, so the first subdev can be 
linked to it. However the truth is that some devices might need a subdev 
instance to model FD engine, while for others it would be completely 
irrelevant. 

...
>> I suggest you to merge this module with next patch and remove what's
>> unnecessary for OMAP4 FDIF. IMHO creating generic object detection
>> module doesn't make sense, given the complexity of hardware. We have
> 
> IMO, at least now there are some functions which can be implemented
> in generic object detection module to avoid duplicated implementation in

I know from experience that inflexible frameworks are worse than no frameworks. 
And I feel we have not enough experience with the object detection devices 
right now to come up with decent generic kernel framework. With only one 
device using your generic OD module it just adds complexity and obfuscates 
things.

> object detection hw driver: interfaces with user space, handling object
> detection from user space images.  We can let object detect hw driver to
> handle the complexity of hardware by defining appropriate callbacks.

I'm still not convinced. I can't see a value in having generic module
the is used only by one driver, given diversity of nowadays media systems.

>> already the required building blocks in v4l2 core, what we need is
>> specification of Face Detection interface semantics, which should be
>> eventually added to the V4L DocBook.
>> The object detection ioctls need to be adjusted to support camera sensors
>> with face detection capability, I'll comment on patch 6/8 about this.
> 
> Expect your comments on it, :-)

I finally managed to find a time to review it. Sorry about the delay.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/app-pri.html

--

Regards,
Sylwester
