Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0FTHm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:42:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47585 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0FTHmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=alerv6fzbxh0YuH+Z4PMxgOHnq8Mo+yuVDf0RDe805TTzzRHLEa96iNO2wKE1InfVv
         nuDtFPczDdOqYJkfAL3xYEuWWAfrfM5OfvMElJorLZQAaU/RCwj6xjsOMwTNRH+Yfldj
         9gMBaVZh0Mfpsn4gkLj7pt5uq9myoESx6DjxE=
MIME-Version: 1.0
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Sun, 20 Jun 2010 00:42:02 -0700
X-Google-Sender-Auth: jlczvJKZJAWczUYgie3rO_rNBk4
Message-ID: <AANLkTik5x38mWno0EUGhaHDD_INLlpeaGSExGxjIC4as@mail.gmail.com>
Subject: Re: wait_for_completion_interruptible does not wait !! [During PM 
	suspend]
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 12:23 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 06/20/2010 08:52 AM, Suresh Rajashekara wrote:
>> The ioctl waits on a completion variable (using
>> wait_for_completion_interruptible).
> ...
>> I tried wait_for_completion instead, but now the kernel refuses to suspend.
>
> Do you check return value of wait_for_completion_interruptible and
> return its value if nonzero?
>
> We need the code to comment, otherwise it's hard to say.

No. I am not checking the return value of the
wait_for_completion_interruptible. I can do it

The code is as follows. I have cut the relevant portion of the code
and pasted in to the email

My test application. The actual application is exactly similar (actual
application has different names)
<SNIP>
void *headset_detect_thread_start ( void *private_date )
{
    int hs_fd = 0;
    int iState = 0;

    hs_fd = open("/dev/adc", O_RDWR);

    if ( hs_fd == -1 ) {
        printf("The headset device could not be opened\n");
        goto hs_thread_exit;
    }

    for (;;) {
       pthread_testcancel();
       ioctl(hs_fd, IOCTL_CODEC_HEADSET_DETECT, &iState);
       pthread_testcancel();

       if ( iState )
           printf("\n++++ Headset Insertion detected\n");
       else
           printf("\n---- Headset Removal detected\n");

       SignalEvent(); // Dummy function, but the actual application
does inside the function
    }

hs_thread_out:
    close(hs_fd);
hs_thread_exit:
    pthread_exit(NULL);
}
</SNIP>


Kernel Code:

/* Code from Ioctl of the codec driver*/
<SNIP>
 case IOCTL_CODEC_HEADSET_DETECT:
       headset_detect();
       headset_detect_state = get_hsdetect_state();
       copy_to_user( argp, &headset_detect_state, sizeof(int)) ;
       break;
</SNIP>

implementation of headset_detect in the codec driver
<SNIP>
void headset_detect(void){
	/* This variable is completed in interrupt handler */
    wait_for_completion_interruptible(&drv_priv->headset_completion);
}
</SNIP>

Thanks,
Suresh
