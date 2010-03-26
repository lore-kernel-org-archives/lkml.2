Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0CZKBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:01:40 -0400
Received: from crca.org.au ([74.207.252.120]:53424 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0CZKBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:01:38 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BAC8634.5000703@crca.org.au>
Date: Fri, 26 Mar 2010 21:02:28 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 11/15] PM / Hibernate: add chunk i/o support
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-11-git-send-email-jslaby@suse.cz> <201003252338.48513.rjw@sisk.pl> <4BAC79B4.4040200@gmail.com>
In-Reply-To: <4BAC79B4.4040200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/03/10 20:09, Jiri Slaby wrote:
> On 03/25/2010 11:38 PM, Rafael J. Wysocki wrote:
>>> +int sws_rw_buffer_init(int writing)
>>> +{
>>> +	BUG_ON(sws_writer_buffer || sws_writer_buffer_pos);
>>
>> Please don't do that.  Fail the operation instead.  You can also use WARN_ON
>> or WARN if you _really_ want the user to notice the failure.
>
> It's not a failure, it's a bug when we leak memory or forgot to
> read/write all data.
>
>> BUG_ON's like this are annoying like hell for testers who trigger them.
>
> I think BUG is appropriate here (the system or image is in an
> inconsitent state for the latter condition), but if you prefer the
> WARN-family here, I can switch it to that.
>
>>> +		if (writing) {
>>> +			ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
>>> +			clear_page(sws_writer_buffer);
>>
>> Why do we need that clear_page()?
>
> Functionally for nothing, it was for my sakeness. Will remove.
>
>>> +int sws_rw_buffer_flush_page(int writing)
>>> +{
>>> +	int ret = 0;
>>> +	if (writing&&  sws_writer_buffer_pos)
>>> +		ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
>>> +	sws_writer_buffer_pos = writing ? 0 : PAGE_SIZE;
>>> +	return ret;
>>> +}
>>
>> I'd split the above into two functions, one for writing and the other for
>> reading.
>>
>> Doing the same with sws_rw_buffer() (under a better name), for the sake of
>> clarity, also might make some sense, apparently.
>
> Do you mean adding hib*_buffer_read + hib*_buffer_write which would call
> static hib*_rw_buffer? sws_rw_buffer has much common code for R and W,
> so I would not make 2 functions from that.
>
> Nigel, you use _rw_ functions in toi, are there any pros opposing to _r_
> + _w_ (apart from exporting twice as symbols)?

I forget now why I used rw functions to begin with (it's been a long 
time!). I do know I've never worried about exporting twice as many symbols.

As I look at the code now, I think it makes more sense to split things 
up. This is especially true when I consider that a user with 4 cores has 
driven me to work on scalability, which will only diverge the code paths 
more.

Regards,

Nigel
