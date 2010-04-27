Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0D0HUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:20:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52980 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0D0HUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dWJgiW02zmdFI9fx5aeXm7zRnRJfmDPbnJEnw2bVtTUIH7Y5Vx93nU1zQa4eH/qV37
         DkMHANegJAsgGVjvtQ4FYj1VGNR7gPe7+B5q8usc21Qc/JbI+CLHQ5nIlPNynF9qNQRM
         efUnYuRefd5Woln1WkQ3i+3RbEw26Hgu/NiSY=
Message-ID: <4BD69047.3010703@gmail.com>
Date: Tue, 27 Apr 2010 09:20:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.5 Thunderbird/3.1b1
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Marcel Holtmann <marcel@holtmann.org>, simon.windows@gmail.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Bug in hidraw When a HID Device Contains Multiple
 Reports
References: <4BD61506.1030301@signal11.us>
In-Reply-To: <4BD61506.1030301@signal11.us>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 12:34 AM, Alan Ott wrote:
> Make hidraw not stick an extra byte on the beginning of an IN transfer
> when a HID device contains multiple reports.
...
> I have attached a patch which seems to take care of this problem. Please
> let me know if I have completely misjudged the situation.

Nope, your analysis is correct. It was introduced by me in 85cdaf524. I
apparently forgot to change the hidraw case, so your fix is OK.

> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 2e2aa75..0e4a6fb 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1043,13 +1043,8 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>  
>  	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
>  		hid->hiddev_report_event(hid, report);
> -	if (hid->claimed & HID_CLAIMED_HIDRAW) {
> -		/* numbered reports need to be passed with the report num */
> -		if (report_enum->numbered)
> -			hidraw_report_event(hid, data - 1, size + 1);
> -		else
> -			hidraw_report_event(hid, data, size);
> -	}
> +	if (hid->claimed & HID_CLAIMED_HIDRAW)
> +		hidraw_report_event(hid, data, size);
>  
>  	for (a = 0; a < report->maxfield; a++)
>  		hid_input_field(hid, report->field[a], cdata, interrupt);

-- 
js
