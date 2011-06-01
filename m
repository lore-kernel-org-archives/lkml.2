Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab1FATpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:45:17 -0400
Received: from smtp.nordnet.fr ([194.206.126.239]:63147 "EHLO smtp.nordnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533Ab1FATpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:45:15 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 15:45:14 EDT
Message-ID: <4DE6950C.3030500@laposte.net>
Date: Wed, 01 Jun 2011 21:37:48 +0200
From: Gilles Hamel <hamelg@laposte.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110503 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Ulrich Keller <uhkeller@googlemail.com>, linux-kernel@vger.kernel.org,
        Thomas Sattler <tsattler@gmx.de>, Gilles Hamel <hamelg@laposte.net>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <4DAF6C0B.3070009@gmx.de> <loom.20110511T124036-180@post.gmane.org> <20110512140352.GG11579@random.random>
In-Reply-To: <20110512140352.GG11579@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 16:03, Andrea Arcangeli wrote:
> On Wed, May 11, 2011 at 10:53:18AM +0000, Ulrich Keller wrote:
>> I am seeing exactly the same symptoms on my Lenovo T60 Core2 duo, 3GB RAM,
>> running Arch Linux i686 with Kernel 2.6.38.6. When I've heavily used Firefox for
>> a while, or used R with high memory usage (>1 GB), individual applications
>> become unresponsive, new processes fail to start and after a while the whole
>> system freezes. When it happens, iotop shows khugepaged and sometimes firefox at
>> 99.99%.
> SYSRQ+T run multiple times during the hang and /proc/zoneinfo as well
> run multiple times during the hang is the best info we can have for
> now, /proc/zoneinfo is the most interesting as it will show us the
> values that the too_many_isolated loop is checking to decide if to
> continue looping.
Me too :(
Since running 2.6.38, it was happening only 3 times on the same process 
(convert from the ImageMagick toolkit). The last time I'm running 2.6.38.7.
This process is launched every 15 minutes by crond, like this :

*/15 * * * * convert -delay 50 
http://www.meteo60.org/radars/radar-nord-picardie-idf{-90,-90,-90,-75,-60,-45,-30,-15,,,}.png 
-loop 0 $HOME/temp/radar-pluie.gif >/dev/null 2>&1
*/15 * * * * convert -delay 50 
http://www.sat24.com/image.ashx\?ok=1\&country=fr\&type=slide\&time=\&index={9,9,9,8,7,6,5,4,3,2,1,1,1}\&sat=vis 
-loop 0 $HOME/temp/radar-nuage.gif >/dev/null 2>&1

When it's happen, I'm using firefox. Here, the whole system continues 
functioning normally a moment, then the X server hangs. Only these 3 
tasks was stuck at 99% io busy in iotop :

$ iotop -ob
Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
    26 be/7 root        0.00 B/s    0.00 B/s  0.00 % 96.84 % [khugepaged]
22839 be/4 hamelg      0.00 B/s    0.00 B/s  0.00 % 96.84 % convert 
-delay 50 http://www.meteo60....
22841 be/4 hamelg      0.00 B/s    0.00 B/s  0.00 % 96.84 % convert 
-delay 50 http://www.sat24....
Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
22839 be/4 hamelg      0.00 B/s    0.00 B/s  0.00 % 99.99 % convert 
-delay 50 http://www.meteo60...
    26 be/7 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [khugepaged]
22841 be/4 hamelg      0.00 B/s    0.00 B/s  0.00 % 99.99 % convert 
-delay 50 http://www.sat24...
...

Before rebooting, I followed your hints. You'll find the output of 
multiple SYSRQ+T, /proc/zoneinfo and ps axu and my config.gz :

http://gilles.hamel.free.fr/config.gz
http://gilles.hamel.free.fr/typescript
http://gilles.hamel.free.fr/sysrq+t.txt

I hope these additional clues will help you to hunt this bug.

Regards


