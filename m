Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0CZJJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:09:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:25394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0CZJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=E1QmP9AniWvBzGvwuVG1Ka+a2auS8WF6uJMdkGQ0aXpQqeiGnUDPSJTe8cYqKkOnez
         3MdrpIXAmy7kcEIDDAgX0Jv6DPzH8JtkByQZ3IVu055PqluLfYB4UoJQDA88vTFgJg46
         d5d9RpQdwX5PJPWIgN7clCnkmtct9Hud5wdYk=
Message-ID: <4BAC79B4.4040200@gmail.com>
Date: Fri, 26 Mar 2010 10:09:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.1 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC 11/15] PM / Hibernate: add chunk i/o support
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-11-git-send-email-jslaby@suse.cz> <201003252338.48513.rjw@sisk.pl>
In-Reply-To: <201003252338.48513.rjw@sisk.pl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 11:38 PM, Rafael J. Wysocki wrote:
>> +int sws_rw_buffer_init(int writing)
>> +{
>> +	BUG_ON(sws_writer_buffer || sws_writer_buffer_pos);
> 
> Please don't do that.  Fail the operation instead.  You can also use WARN_ON
> or WARN if you _really_ want the user to notice the failure.

It's not a failure, it's a bug when we leak memory or forgot to
read/write all data.

> BUG_ON's like this are annoying like hell for testers who trigger them.

I think BUG is appropriate here (the system or image is in an
inconsitent state for the latter condition), but if you prefer the
WARN-family here, I can switch it to that.

>> +		if (writing) {
>> +			ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
>> +			clear_page(sws_writer_buffer);
> 
> Why do we need that clear_page()?

Functionally for nothing, it was for my sakeness. Will remove.

>> +int sws_rw_buffer_flush_page(int writing)
>> +{
>> +	int ret = 0;
>> +	if (writing && sws_writer_buffer_pos)
>> +		ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
>> +	sws_writer_buffer_pos = writing ? 0 : PAGE_SIZE;
>> +	return ret;
>> +}
> 
> I'd split the above into two functions, one for writing and the other for
> reading.
> 
> Doing the same with sws_rw_buffer() (under a better name), for the sake of
> clarity, also might make some sense, apparently.

Do you mean adding hib*_buffer_read + hib*_buffer_write which would call
static hib*_rw_buffer? sws_rw_buffer has much common code for R and W,
so I would not make 2 functions from that.

Nigel, you use _rw_ functions in toi, are there any pros opposing to _r_
+ _w_ (apart from exporting twice as symbols)?

thanks,
-- 
js
