Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0KPGBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:01:10 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:39709 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab0KPGBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:01:09 -0500
Message-ID: <4CE21E17.70107@freemail.hu>
Date: Tue, 16 Nov 2010 07:00:55 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
References: <4CD8ECE4.1090206@freemail.hu>	<20101109075056.59a2e7d8@lembas.zaitcev.lan>	<4CD9A96D.1010306@freemail.hu>	<4CDF0DF4.4020405@freemail.hu>	<20101114124035.6a0c9b80@lembas.zaitcev.lan>	<4CE0458E.9070900@freemail.hu> <20101114162502.6d6318e7@lembas.zaitcev.lan> <4CE0C9B8.1010403@freemail.hu>
In-Reply-To: <4CE0C9B8.1010403@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> Hi Pete,
> Pete Zaitcev wrote:
>> On Sun, 14 Nov 2010 21:24:46 +0100
>> Németh Márton <nm127@freemail.hu> wrote:
>>
>>> Sure, I'm happy as long as I can capture the whole data content of the ISO
>>> packets.
>> Great. So, what do you think about the attached? It differs from your
>> code in one important aspect: output buffer sizes are not adjusted.
>> Your patch attempts that, but uses actual_length, which is not
>> defined during submission events. So I skipped that.
> 
> I think there are four cases for ISO communication URBs:
> 
> ev_type == 'S' && usb_urb_dir_in(urb)  ---> we don't need the data
> ev_type == 'C' && usb_urb_dir_in(urb)  ---> data is available, we'll need it
> ev_type == 'S' && usb_urb_dir_out(urb)  ---> data is available, we'll need it
> ev_type == 'C' && usb_urb_dir_out(urb)  ---> we don't need the data
> 
> I cannot say for sure which field contains the length in case of ISO out submit
> URBs.
> 
> I'll test the patch later in my environment.

I tested this patch with ISO in traffic and it works for me.

>> diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
>> index 44cb37b..15c5e46 100644
>> --- a/drivers/usb/mon/mon_bin.c
>> +++ b/drivers/usb/mon/mon_bin.c
>> @@ -437,6 +437,28 @@ static unsigned int mon_bin_get_data(const struct mon_reader_bin *rp,
>>  	return length;
>>  }
>>  
>> +/*
>> + * This is the look-ahead pass in case of 'Ci', when actual_length cannot
>> + * be used to determine the length of the whole contiguous buffer.
>> + */
>> +static unsigned int mon_bin_collate_isodesc(const struct mon_reader_bin *rp,
>> +    struct urb *urb, unsigned int ndesc)
>> +{
>> +	struct usb_iso_packet_descriptor *fp;
>> +	unsigned int length;
>> +
>> +	length = 0;
>> +	fp = urb->iso_frame_desc;
>> +	while (ndesc-- != 0) {
>> +		if (fp->status == 0 && fp->actual_length != 0) {
>> +			if (fp->offset + fp->actual_length > length)
>> +				length = fp->offset + fp->actual_length;
> 
> I don't know whether the compiler will optimize the two times computing the
> expression (fp->offset + fp->actual_length). Maybe I would use a local variable
> to compute the sum before the "if" and then use just the local variable.
> 
>> +		}
>> +		fp++;
>> +	}
>> +	return length;
>> +}
>> +
>>  static void mon_bin_get_isodesc(const struct mon_reader_bin *rp,
>>      unsigned int offset, struct urb *urb, char ev_type, unsigned int ndesc)
>>  {
>> @@ -479,6 +501,10 @@ static void mon_bin_event(struct mon_reader_bin *rp, struct urb *urb,
>>  	/*
>>  	 * Find the maximum allowable length, then allocate space.
>>  	 */
>> +	urb_length = (ev_type == 'S') ?
>> +	    urb->transfer_buffer_length : urb->actual_length;
>> +	length = urb_length;
>> +
>>  	if (usb_endpoint_xfer_isoc(epd)) {
>>  		if (urb->number_of_packets < 0) {
>>  			ndesc = 0;
>> @@ -487,14 +513,16 @@ static void mon_bin_event(struct mon_reader_bin *rp, struct urb *urb,
>>  		} else {
>>  			ndesc = urb->number_of_packets;
>>  		}
>> +		if (ev_type == 'C' && usb_urb_dir_in(urb))
>> +			length = mon_bin_collate_isodesc(rp, urb, ndesc);
>>  	} else {
>>  		ndesc = 0;
>>  	}
>>  	lendesc = ndesc*sizeof(struct mon_bin_isodesc);
>>  
>> -	urb_length = (ev_type == 'S') ?
>> -	    urb->transfer_buffer_length : urb->actual_length;
>> -	length = urb_length;
>> +	/* not an issue unless there's a subtle bug in a HCD somewhere */
>> +	if (length >= urb->transfer_buffer_length)
>> +		length = urb->transfer_buffer_length;
>>  
>>  	if (length >= rp->b_size/5)
>>  		length = rp->b_size/5;
>>
>>
> 
> 

