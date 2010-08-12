Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab0HLDuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:50:22 -0400
Received: from ppp167-251-209.static.internode.on.net ([59.167.251.209]:39481
	"EHLO protos.guarana.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758912Ab0HLDuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:50:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 23:50:21 EDT
Message-ID: <20100812134338.14856uchty1ra39c@guarana.org>
Date: Thu, 12 Aug 2010 13:43:38 +1000
From: Kevin Easton <kevin@guarana.org>
To: Micha Nelissen <micha@neli.hopto.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is get_user_pages so slow?
References: <4C61AD7A.7040400@neli.hopto.org>
In-Reply-To: <4C61AD7A.7040400@neli.hopto.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Micha Nelissen <micha@neli.hopto.org>:

> Hi all,
>
> Why is get_user_pages much slower than taking the faults? (I would  
> expect it to be faster).
>
> Attached example program first mallocs a piece of memory (64MB in  
> this case) then reads it "to take the faults". Afterwards, it uses  
> mmap with MAP_POPULATE to "speed up" and not to have to take the  
> faults, but have everything mapped in one go. I think mmap is using  
> get_user_pages in this case.
>
> $ ./memspeed
> malloc took 0 msecs
> read took 14 msecs
> write took 0 msecs
> free took 1 msecs
> mmap took 45 msecs
> munmap took 5 msecs
>
> Using MAP_POPULATE is 3 times as slow as the 'stupid'  
> implementation! I'm running a Core 2 duo e6300 system with linux  
> 2.6.28.4.
>
> Am I doing something wrong? MAP_POPULATE seems a bit of a joke to me.

Hi Micha,

Yep, you are.  Because your pointer 'p' is a pointer to int, when you  
increment it by 0x1000 in your loops you are actually incrementing it  
by 0x1000 * sizeof(int) - so you're only actually touching one page in  
four.

If you change the types of 'buf', 'p' and 'e' to 'char *' then it  
touches every page - and (and least on my test box) the MAP_POPULATE  
case pulls ahead.

     - Kevin



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

