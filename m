Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1CaMiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:38:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1CaMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PRpdj05bSJGR7jX3q7h+PF98AVMRl52g/slDWp6shp62jkAcx8BB4OARKK4XoHFTfR
         Sgd7n0lBuJSjNbAjg0LQLtFDUlIlxKOgLtyC9f7DxkmieoFtDt8Sjwmsc8pq8YMPgkSX
         hxhT4wxlKq4oK04+WZsCfn1lo5y4l16sHiKdo=
MIME-Version: 1.0
In-Reply-To: <20110328214504.GC2786@local>
References: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
	<20110328214504.GC2786@local>
Date: Thu, 31 Mar 2011 20:38:47 +0800
Message-ID: <AANLkTi=AqMzS_cC1WRB+Knx1GT_Oha01kOyxC1TqyWxE@mail.gmail.com>
Subject: Re: [PATCH] uio: fix allocating minor id for uio device
From: Hillf Danton <dhillf@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of uio devices that could be used should be less than
UIO_MAX_DEVICES by design, and this work guards any cases in which id
more than UIO_MAX_DEVICES is utilized.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
+++ b/drivers/uio/uio.c	2011-03-31 20:43:44.000000000 +0800
@@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_devi
 			retval = -ENOMEM;
 		goto exit;
 	}
-	idev->minor = id & MAX_ID_MASK;
+	if (id < UIO_MAX_DEVICES) {
+		idev->minor = id;
+	} else {
+		dev_err(idev->dev, "too many uio devices\n");
+		retval = -EINVAL;
+		idr_remove(&uio_idr, id);
+	}
 exit:
 	mutex_unlock(&minor_lock);
 	return retval;
