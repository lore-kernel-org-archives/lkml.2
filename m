Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2JIBm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 21:42:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60412 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2JIBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 21:42:57 -0400
Message-ID: <507380F8.4000401@linaro.org>
Date: Mon, 08 Oct 2012 18:42:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>, Arve Hj?nnev?g <arve@android.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Subject: Re: [RFC] vmevent: Implement pressure attribute
References: <20121004110524.GA1821@lizard> <20121005092912.GA29125@suse.de> <20121007081414.GA18047@lizard> <20121008094646.GI29125@suse.de>
In-Reply-To: <20121008094646.GI29125@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100901-7282-0000-0000-00000DB9F70E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 02:46 AM, Mel Gorman wrote:
> On Sun, Oct 07, 2012 at 01:14:17AM -0700, Anton Vorontsov wrote:
>> And here we just try to let userland to assist, userland can tell "oh,
>> don't bother with swapping or draining caches, I can just free some
>> memory".
>>
>> Quite interesting, this also very much resembles volatile mmap ranges
>> (i.e. the work that John Stultz is leading in parallel).
>>
> Agreed. I haven't been paying close attention to those patches but it
> seems to me that one possiblity is that a listener for a vmevent would
> set volatile ranges in response.

I don't have too much to comment on the rest of this mail, but just 
wanted to pipe in here, as the volatile ranges have caused some confusion.

While your suggestion would be possible, with volatile ranges, I've been 
promoting a more hands off-approach from the application perspective, 
where the application always would mark data that could be regenerated 
as volatile, unmarking it when accessing it.

This way the application doesn't need to be responsive to memory 
pressure, the kernel just takes what it needs from what the application 
made available.

Only when the application needs the data again, would it mark it 
non-volatile (or alternatively with the new SIGBUS semantics, access the 
purged volatile data and catch a SIGBUS), find the data was purged and 
regenerate it.

That said, hybrid approaches like you suggested would be possible, but 
at a certain point, if we're waiting for a notification to take action, 
it might be better just to directly free that memory, rather then just 
setting it as volatile, and leaving it to the kernel then reclaim it for 
you.

thanks
-john

