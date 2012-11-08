Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2KHCHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:07:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:50257 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab2KHCHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:07:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,735,1344236400"; 
   d="scan'208";a="243905530"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ming Lei <ming.lei@canonical.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
Thread-Topic: [PATCH V2] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
Thread-Index: AQHNvVUMRHSSh77CEkSEU8Zrcs9JzpffL+QA
Date: Thu, 8 Nov 2012 02:07:19 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1BFAE8@SHSMSX101.ccr.corp.intel.com>
References: <1352306744.15558.1608.camel@cliu38-desktop-build>
	<1352370563.15558.1613.camel@cliu38-desktop-build>
 <CACVXFVMKtkp3xna6C-G04sUqOm+7H4FEN-UZjyVQUfdfCPPBnw@mail.gmail.com>
In-Reply-To: <CACVXFVMKtkp3xna6C-G04sUqOm+7H4FEN-UZjyVQUfdfCPPBnw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@canonical.com]
> Sent: Thursday, November 08, 2012 10:02 AM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V2] firmware loader: Fix the race FW_STATUS_DONE is
> followed by class_timeout
> 
> On Thu, Nov 8, 2012 at 6:29 PM, Chuansheng Liu <chuansheng.liu@intel.com>
> wrote:
> >
> > There is a race as below when calling request_firmware():
> > CPU1                                   CPU2
> > write 0 > loading
> > mutex_lock(&fw_lock)
> > ...
> > set_bit FW_STATUS_DONE                 class_timeout is coming
> >                                        set_bit FW_STATUS_ABORT
> > complete_all &completion
> > ...
> > mutex_unlock(&fw_lock)
> >
> > In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
> > and request_firmware() will return failure due to condition in
> > _request_firmware_load():
> >         if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
> >                 retval = -ENOENT;
> >
> > But from the above scenerio, it should be a successful requesting.
> > So we need judge if the bit FW_STATUS_DONE is already set before
> > calling fw_load_abort() in timeout function.
> >
> > As Ming's proposal, we need change the timer into sched_work to
> > benefit from using &fw_lock mutex also.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/base/firmware_class.c |   25 +++++++++++++++++--------
> >  1 files changed, 17 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 8945f4e..f2caa0a 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -143,7 +143,7 @@ struct fw_cache_entry {
> >  };
> >
> >  struct firmware_priv {
> > -       struct timer_list timeout;
> > +       struct delayed_work timeout_work;
> >         bool nowait;
> >         struct device dev;
> >         struct firmware_buf *buf;
> > @@ -667,10 +667,17 @@ static struct bin_attribute firmware_attr_data = {
> >         .write = firmware_data_write,
> >  };
> >
> > -static void firmware_class_timeout(u_long data)
> > +static void firmware_class_timeout_work(struct work_struct *work)
> >  {
> > -       struct firmware_priv *fw_priv = (struct firmware_priv *) data;
> > +       struct firmware_priv *fw_priv = container_of(work,
> > +                       struct firmware_priv, timeout_work.work);
> >
> > +       mutex_lock(&fw_lock);
> > +       if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
> > +               mutex_unlock(&fw_lock);
> > +               return;
> > +       }
> > +       mutex_unlock(&fw_lock);
> >         fw_load_abort(fw_priv);
> 
> fw_lock should be held when fw_load_abort(fw_priv) is running.
OK.

> 
> >  }
> >
> > @@ -690,8 +697,8 @@ fw_create_instance(struct firmware *firmware,
> const char *fw_name,
> >
> >         fw_priv->nowait = nowait;
> >         fw_priv->fw = firmware;
> > -       setup_timer(&fw_priv->timeout,
> > -                   firmware_class_timeout, (u_long) fw_priv);
> > +       INIT_DELAYED_WORK(&fw_priv->timeout_work,
> > +               firmware_class_timeout_work);
> >
> >         f_dev = &fw_priv->dev;
> >
> > @@ -858,7 +865,9 @@ static int _request_firmware_load(struct
> firmware_priv *fw_priv, bool uevent,
> >                 dev_dbg(f_dev->parent, "firmware: direct-loading"
> >                         " firmware %s\n", buf->fw_id);
> >
> > +               mutex_lock(&fw_lock);
> >                 set_bit(FW_STATUS_DONE, &buf->status);
> > +               mutex_unlock(&fw_lock);
> >                 complete_all(&buf->completion);
> >                 direct_load = 1;
> >                 goto handle_fw;
> > @@ -894,15 +903,15 @@ static int _request_firmware_load(struct
> firmware_priv *fw_priv, bool uevent,
> >                 dev_set_uevent_suppress(f_dev, false);
> >                 dev_dbg(f_dev, "firmware: requesting %s\n",
> buf->fw_id);
> >                 if (timeout != MAX_SCHEDULE_TIMEOUT)
> > -                       mod_timer(&fw_priv->timeout,
> > -                                 round_jiffies_up(jiffies + timeout));
> > +
> schedule_delayed_work(&fw_priv->timeout_work,
> > +                                       timeout * HZ);
> 
> timeout is in unit of jiffies already, so multiplying by 'HZ' isn't needed.
Oh, sorry for that, I just tested it in one old version.
Will update the patch soon.

> 
> >
> >                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
> >         }
> >
> >         wait_for_completion(&buf->completion);
> >
> > -       del_timer_sync(&fw_priv->timeout);
> > +       cancel_delayed_work_sync(&fw_priv->timeout_work);
> >
> >  handle_fw:
> >         mutex_lock(&fw_lock);
> > --
> > 1.7.0.4
> >
> >
> >
> 
> Thanks,
> --
> Ming Lei
