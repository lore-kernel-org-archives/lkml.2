Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0JRJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:27:16 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:42833 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0JRJ1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:27:14 -0400
Message-ID: <4CBC12EC.60109@bfs.de>
Date: Mon, 18 Oct 2010 11:27:08 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/staging/cx25821: Use kasprintf
References: <1287341311-11161-1-git-send-email-julia@diku.dk> <1287341311-11161-2-git-send-email-julia@diku.dk> <4CBBF407.7060705@bfs.de> <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1010181019370.22530@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> On Mon, 18 Oct 2010, walter harms wrote:
> 
>>
>> Julia Lawall schrieb:
>>> Rewrite the initialization of a dev field.  In the original code, in each
>>> case there was a kmalloc followed by a memcpy, as illustrated by the
>>> semantic patch below.  In the case that the provided string was the empty
>>> string, the allocated memory was then overwritten with a constant string,
>>> causing a memory leak.  Finally, there was no provision for returning
>>> -ENOMEM in case of failure of the memory allocation.  Indeed, the return
>>> value in an error case was err, a variable that was never initialized to
>>> anything other than 0.
>>>
>>> The following patch rewrites the above code to first select a string based
>>> on various conditions, and then to copy it into a newly allocated memory
>>> region, using kasprintf.  This decreases subtantially the code size
>>> and removes the memory leak.  The instruction for getting the length of the
>>> string and the associated variable declaration are also deleted.
>>>
>>> The patch also drops err, changes the return value to retval, which in each
>>> file was already initialized elsewhere to an error code, and initializes
>>> retval to -ENOMEM when kasprintf fails.
>>>
>>> The semantic patch that motivated this transformation is:
>>> (http://coccinelle.lip6.fr/)
>>>
>>> // <smpl>
>>> @@
>>> expression a,flag,len;
>>> expression arg,e1,e2;
>>> statement S;
>>> @@
>>>
>>>   len = strlen(arg)
>>>   ... when != len = e1
>>>       when != arg = e2
>>>   a =
>>> -  \(kmalloc\|kzalloc\)(len+1,flag)
>>> +  kasprintf(flag,"%s",arg)
>>>   <... when != a
>>>   if (a == NULL || ...) S
>>>   ...>
>>> - memcpy(a,arg,len+1);
>>> // </smpl>
>>>
>>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>>
>>> ---
>>> This patch makes quite a lot of changes and is only compile tested.
>>>
>>>  drivers/staging/cx25821/cx25821-audio-upstream.c     |   36 +++---------
>>>  drivers/staging/cx25821/cx25821-video-upstream-ch2.c |   57 +++++++------------
>>>  drivers/staging/cx25821/cx25821-video-upstream.c     |   56 +++++++-----------
>>>  3 files changed, 56 insertions(+), 93 deletions(-)
>>>
>>> diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> index 27087db..a8f6343 100644
>>> --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> @@ -723,8 +723,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>>>  {
>>>  	struct sram_channel *sram_ch;
>>>  	int retval = 0;
>>> -	int err = 0;
>>> -	int str_length = 0;
>>> +	char *filename;
>>>  
>>>  	if (dev->_audio_is_running) {
>>>  		printk(KERN_WARNING "Audio Channel is still running so return!\n");
>>> @@ -752,28 +751,15 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>>>  	dev->_audio_lines_count = LINES_PER_AUDIO_BUFFER;
>>>  	_line_size = AUDIO_LINE_SIZE;
>>>  
>>> -	if (dev->input_audiofilename) {
>>> -		str_length = strlen(dev->input_audiofilename);
>>> -		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>>> -
>>> -		if (!dev->_audiofilename)
>>> -			goto error;
>>> -
>>> -		memcpy(dev->_audiofilename, dev->input_audiofilename,
>>> -		       str_length + 1);
>>> -
>>> -		/* Default if filename is empty string */
>>> -		if (strcmp(dev->input_audiofilename, "") == 0)
>>> -			dev->_audiofilename = "/root/audioGOOD.wav";
>>> -
>>> -	} else {
>>> -		str_length = strlen(_defaultAudioName);
>>> -		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>>> -
>>> -		if (!dev->_audiofilename)
>>> -			goto error;
>>> -
>>> -		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
>>> +	if (dev->input_audiofilename &&
>>> +	    strcmp(dev->input_audiofilename, "") != 0)
>>> +		filename = dev->input_audiofilename;
>>> +	else
>>> +		filename = _defaultAudioName;
>>> +	dev->_audiofilename = kasprintf(GFP_KERNEL, "%s", filename);
>>> +	if (!dev->_audiofilename) {
>>> +		retval = -ENOMEM;
>>> +		goto error;
>>>  	}
>>>
>> Is filename needed here at all ?
> 
> I'm not sure to understand the question.  There indeed appear to be 
> different options.  The kasprintf (which seems like it could be changed to 
> kstrdup) could indeed be moved into the two branches, but it seemed nicer 
> to have only one function call and one block of error handling code, since 
> the error handling code is identical.


the long version is:

the variable char * filename seems to be used as tmp buffer for the result of
the if statement. IMHO you could use dev->_audiofilename directly without loss
of clarity.

Turning the if condition on its head (and removing the strcmp) is the way i would
check. Please see this a comment the result is of cause identical.

hope that helps
re
 wh



> 
>> The if statement looks strange this looks more familar to me:
>> if (!dev->input_audiofilename || *dev->input_audiofilename==0)
>> 	filename = _defaultAudioName;
>> else
>> 	filename = dev->input_audiofilename;
> 
> OK.
> 



