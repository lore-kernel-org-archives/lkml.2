Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2IJQKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:10:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49212 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab2IJQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:10:32 -0400
From: Thomas Lendacky <tahm@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache when possible
Date: Mon, 10 Sep 2012 11:01:06 -0500
Message-ID: <3011045.XPVFy0hMGs@tomlt1.ibmoffice.com>
User-Agent: KMail/4.8.5 (Linux/3.4.9-2.fc16.i686.PAE; KDE/4.8.5; i686; ; )
In-Reply-To: <87txvahfv3.fsf@rustcorp.com.au>
References: <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120906084526.GE17656@redhat.com> <87txvahfv3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091016-7182-0000-0000-0000028EB972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 07, 2012 09:19:04 AM Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Thu, Sep 06, 2012 at 05:27:23PM +0930, Rusty Russell wrote:
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> > Yes without checksum net core always linearizes packets, so yes it is
> >> > screwed.
> >> > For -net, skb always allocates space for 17 frags + linear part so
> >> > it seems sane to do same in virtio core, and allocate, for -net,
> >> > up to max_frags + 1 from cache.
> >> > We can adjust it: no _SG -> 2 otherwise 18.
> >> 
> >> But I thought it used individual buffers these days?
> > 
> > Yes for receive, no for transmit. That's probably why
> > we should have the threshold per vq, not per device, BTW.
> 
> Can someone actually run with my histogram patch and see what the real
> numbers are?

Somehow some HTML got in my first reply, resending...

I ran some TCP_RR and TCP_STREAM sessions, both host-to-guest and
guest-to-host, with a form of the histogram patch applied against a
RHEL6.3 kernel. The histogram values were reset after each test.

Here are the results:

60 session TCP_RR from host-to-guest with 256 byte request and 256 byte
response for 60 seconds:

Queue histogram for virtio1:
Size distribution for input (max=7818456):
 1: 7818456 ################################################################
Size distribution for output (max=7816698):
 2: 149     
 3: 7816698 ################################################################
 4: 2       
 5: 1       
Size distribution for control (max=1):
 0: 0


4 session TCP_STREAM from host-to-guest with 4K message size for 60 seconds:

Queue histogram for virtio1:
Size distribution for input (max=16050941):
 1: 16050941 ################################################################
Size distribution for output (max=1877796):
 2: 1877796 ################################################################
 3: 5       
Size distribution for control (max=1):
 0: 0

4 session TCP_STREAM from host-to-guest with 16K message size for 60 seconds:

Queue histogram for virtio1:
Size distribution for input (max=16831151):
 1: 16831151 ################################################################
Size distribution for output (max=1923965):
 2: 1923965 ################################################################
 3: 5       
Size distribution for control (max=1):
 0: 0

4 session TCP_STREAM from guest-to-host with 4K message size for 60 seconds:

Queue histogram for virtio1:
Size distribution for input (max=1316069):
 1: 1316069 ################################################################
Size distribution for output (max=879213):
 2: 24      
 3: 24097   #
 4: 23176   #
 5: 3412    
 6: 4446    
 7: 4663    
 8: 4195    
 9: 3772    
10: 3388    
11: 3666    
12: 2885    
13: 2759    
14: 2997    
15: 3060    
16: 2651    
17: 2235    
18: 92721   ######  
19: 879213  ################################################################
Size distribution for control (max=1):
 0: 0

4 session TCP_STREAM from guest-to-host with 16K message size for 60 seconds:

Queue histogram for virtio1:
Size distribution for input (max=1428590):
 1: 1428590 ################################################################
Size distribution for output (max=957774):
 2: 20
 3: 54955   ###
 4: 34281   ##
 5: 2967
 6: 3394
 7: 9400
 8: 3061
 9: 3397
10: 3258
11: 3275
12: 3147
13: 2876
14: 2747
15: 2832
16: 2013
17: 1670
18: 100369  ######
19: 957774  ################################################################
Size distribution for control (max=1):
 0: 0

Thanks,
Tom

> 
> I'm not convinced that the ideal 17-buffer case actually happens as much
> as we think.  And if it's not happening with this netperf test, we're
> testing the wrong thing.
> 
> Thanks,
> Rusty.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

