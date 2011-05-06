Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1EFOym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:54:42 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:57881 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1EFOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:54:41 -0400
X-WSS-ID: 0LKS434-0B-6JC-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <4DC40B94.9060903@sandia.gov>
Date: Fri, 6 May 2011 08:54:12 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: "Greg KH" <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "James Bottomley" <James.Bottomley@suse.de>
Subject: Re: [patch 04/38] [SCSI] put stricter guards on queue dead
 checks
References: <20110506001207.658271797@clark.kroah.org>
In-Reply-To: <20110506001207.658271797@clark.kroah.org>
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.5.6.144514
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS
 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, WEBMAIL_SOURCE 0, WEBMAIL_XOIP
 0, WEBMAIL_X_IP_HDR 0, __BOUNCE_CHALLENGE_SUBJ 0,
 __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0,
 __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_XOIP 0, __MIME_TEXT_ONLY 0,
 __MIME_VERSION 0, __MOZILLA_MSGID 0, __RATWARE_X_MAILER_CS_B 0,
 __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS , __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110506145419; ID=1; SEV=2.3.1;
 DFV=B2011050614; IFV=NA; AIF=B2011050614; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230352E34444334304239422E303038393A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABADrBBQAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2011050614_5.03.0010
X-WSS-ID: 61DAD4112TS3048118-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.

You probably don't want to add this patch to stable kernels
until commit c055f5b2614b4f from
   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
shows up in Linus' tree.

See details in http://www.spinics.net/lists/kernel/msg1181665.html.

-- Jim


> 
> ------------------
> 
> From: James Bottomley <James.Bottomley@suse.de>
> 
> commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b upstream.
> 
> SCSI uses request_queue->queuedata == NULL as a signal that the queue
> is dying.  We set this state in the sdev release function.  However,
> this allows a small window where we release the last reference but
> haven't quite got to this stage yet and so something will try to take
> a reference in scsi_request_fn and oops.  It's very rare, but we had a
> report here, so we're pushing this as a bug fix
> 
> The actual fix is to set request_queue->queuedata to NULL in
> scsi_remove_device() before we drop the reference.  This causes
> correct automatic rejects from scsi_request_fn as people who hold
> additional references try to submit work and prevents anything from
> getting a new reference to the sdev that way.
> 
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -322,14 +322,8 @@ static void scsi_device_dev_release_user
>  		kfree(evt);
>  	}
>  
> -	if (sdev->request_queue) {
> -		sdev->request_queue->queuedata = NULL;
> -		/* user context needed to free queue */
> -		scsi_free_queue(sdev->request_queue);
> -		/* temporary expedient, try to catch use of queue lock
> -		 * after free of sdev */
> -		sdev->request_queue = NULL;
> -	}
> +	/* NULL queue means the device can't be used */
> +	sdev->request_queue = NULL;
>  
>  	scsi_target_reap(scsi_target(sdev));
>  
> @@ -937,6 +931,12 @@ void __scsi_remove_device(struct scsi_de
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
> +
> +	/* cause the request function to reject all I/O requests */
> +	sdev->request_queue->queuedata = NULL;
> +
> +	/* Freeing the queue signals to block that we're done */
> +	scsi_free_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


