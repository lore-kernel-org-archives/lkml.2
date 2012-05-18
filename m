Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2ERETT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:19:19 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:55712 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2ERETR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:19:17 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 May 2012 12:19:02 +0800
Subject: RE: [PATCH 1/1] usb: gadget/uvc: Add support for
 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
Thread-Topic: [PATCH 1/1] usb: gadget/uvc: Add support for
 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
Thread-Index: Ac00f4d4vEkyaVAeQJanTCsmbYorvQALXz8A
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA5A81253@EAPEX1MAIL1.st.com>
References: <65fb24c9f639ec8cedab04799bc59d43c5683a08.1336374550.git.bhupesh.sharma@st.com>
 <2118581.uka9oG77q2@avalon>
In-Reply-To: <2118581.uka9oG77q2@avalon>
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

Hi Laurent,

Thanks for your review.

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, May 18, 2012 4:21 AM
> To: Bhupesh SHARMA
> Cc: linux-usb@vger.kernel.org; balbi@ti.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] usb: gadget/uvc: Add support for
> 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
> 
> Hi Bhupesh,
> 
> Thank you for the patch.
> 
> On Monday 07 May 2012 12:42:37 Bhupesh Sharma wrote:
> > This patch adds the support in UVC webcam gadget design for providing
> > USB_GADGET_DELAYED_STATUS in response to a set_interface(alt setting
> 1)
> > command issue by the Host.
> >
> > The current UVC webcam gadget design generates a STREAMON event
> > corresponding to a set_interface(alt setting 1) command from the
> Host.
> > This STREAMON event will eventually be routed to a real V4L2 device.
> >
> > To start video streaming, it may be required to perform some register
> writes
> > to a camera sensor device over slow external busses like I2C or SPI.
> So, it
> > makes sense to ensure that we delay the STATUS stage of the
> > set_interface(alt setting 1) command.
> >
> > Otherwise, a lot of ISOC IN tokens sent by the Host will be replied
> to by
> > zero-length packets by the webcam device. On certain Hosts this may
> even
> > lead to ISOC URBs been cancelled from the Host side.
> 
> Very good point.
> 
> > So, as soon as we finish doing all the "streaming" related stuff on
> the real
> > V4L2 device, we call a STREAMON ioctl on the UVC side and from here
> we call
> > the 'usb_composite_setup_continue' function to complete the status
> stage of
> > the set_interface(alt setting 1) command.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > ---
> >  drivers/usb/gadget/f_uvc.c    |   12 +++++++++++-
> >  drivers/usb/gadget/uvc.h      |    4 ++++
> >  drivers/usb/gadget/uvc_v4l2.c |   27 +++++++++++++++++++++++++--
> >  3 files changed, 40 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
> > index d2569b2..6f084e3 100644
> > --- a/drivers/usb/gadget/f_uvc.c
> > +++ b/drivers/usb/gadget/f_uvc.c
> > @@ -209,6 +209,14 @@ uvc_function_get_alt(struct usb_function *f,
> unsigned
> > interface) return uvc->state == UVC_STATE_STREAMING ? 1 : 0;
> >  }
> >
> > +void
> > +uvc_process_setup_continue(struct uvc_device *uvc)
> 
> No need for a line split, this won't exceed the 80 columns limit.

I just wanted to be in sync with existing function definition in UVC gadget.
But I will change this :)
 
> Could you please rename the function to uvc_function_setup_continue to
> be
> coherent with the other non-static functions in this file (and, while
> you're
> at it, move it right above uvc_function_get_alt) ?

Ok.

> > +{
> > +	struct usb_composite_dev *cdev = uvc->func.config->cdev;
> > +
> > +	usb_composite_setup_continue(cdev);
> > +}
> > +
> >  static int
> >  uvc_function_set_alt(struct usb_function *f, unsigned interface,
> unsigned
> > alt) {
> > @@ -271,7 +279,9 @@ uvc_function_set_alt(struct usb_function *f,
> unsigned
> > interface, unsigned alt) v4l2_event_queue(uvc->vdev, &v4l2_event);
> >
> >  		uvc->state = UVC_STATE_STREAMING;
> > -		break;
> > +		uvc->vdev_is_streaming = false;
> 
> Do you think you could combine the state and vdev_is_streaming fields ?
> Maybe
> adding a UVC_STATE_PRE_STREAMING state would be enough, you could set
> the
> state to that value here, and then set it to UVC_STATE_STREAMING in the
> STREAMON ioctl handler (I would actually prefer doing that in the
> uvc_video_enable function).
> 
> If you think it makes sense, could you please try it ?

Seems fine to me. I will give it a try and update my results soon.

> 
> > +
> > +		return USB_GADGET_DELAYED_STATUS;
> 
> Could you please move the return 0 at the end of this function to the
> case 0
> above ? Each case will then have its return statement.

Ok.
 
> >  	default:
> >  		return -EINVAL;
> > diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> > index bc78c60..56ac883 100644
> > --- a/drivers/usb/gadget/uvc.h
> > +++ b/drivers/usb/gadget/uvc.h
> > @@ -168,6 +168,9 @@ struct uvc_device
> >  	/* Events */
> >  	unsigned int event_length;
> >  	unsigned int event_setup_out : 1;
> > +
> > +	/* flags */
> > +	bool vdev_is_streaming;
> >  };
> >
> >  static inline struct uvc_device *to_uvc(struct usb_function *f)
> > @@ -188,6 +191,7 @@ struct uvc_file_handle
> >   * Functions
> >   */
> >
> > +extern void uvc_process_setup_continue(struct uvc_device *uvc);
> >  extern void uvc_endpoint_stream(struct uvc_device *dev);
> >
> >  extern void uvc_function_connect(struct uvc_device *uvc);
> > diff --git a/drivers/usb/gadget/uvc_v4l2.c
> b/drivers/usb/gadget/uvc_v4l2.c
> > index f761bcb..379d8ac 100644
> > --- a/drivers/usb/gadget/uvc_v4l2.c
> > +++ b/drivers/usb/gadget/uvc_v4l2.c
> > @@ -242,7 +242,18 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned
> int cmd,
> > void *arg) if ((ret = uvc_queue_buffer(&video->queue, arg)) < 0)
> >  			return ret;
> >
> > -		return uvc_video_pump(video);
> > +		/*
> > +		 * for the very first QBUF calls (until STREAMON is
> > +		 * called) we just need to queue the buffers and start
> > +		 * pumping the data to USB side only after STREAMON has
> > +		 * been called which is handled by the STREAMON case
> > +		 * below. For QBUF calls after STREAMON, we need to pump
> > +		 * the data to the USB side here itself.
> > +		 */
> > +		if (uvc->vdev_is_streaming)
> > +			return uvc_video_pump(video);
> > +
> > +		return 0;
> >
> >  	case VIDIOC_DQBUF:
> >  		return uvc_dequeue_buffer(&video->queue, arg,
> > @@ -255,7 +266,19 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned
> int cmd,
> > void *arg) if (*type != video->queue.type)
> >  			return -EINVAL;
> >
> > -		return uvc_video_enable(video, 1);
> > +		ret = uvc_video_enable(video, 1);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/*
> > +		 * since the real video device has now started streaming
> > +		 * its safe now to complete the status phase of the
> > +		 * set_interface (alt setting 1)
> > +		 */
> > +		uvc_process_setup_continue(uvc);
> > +		uvc->vdev_is_streaming = true;
> 
> Could you please move this to uvc_video_enable() ?

Ok.
 
> > +
> > +		return 0;
> >  	}
> >
> >  	case VIDIOC_STREAMOFF:
> 

Regards,
Bhupesh
