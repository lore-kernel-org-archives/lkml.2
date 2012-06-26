Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2FZVqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:46:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2FZVqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:46:45 -0400
Message-ID: <4FEA2D85.60002@redhat.com>
Date: Tue, 26 Jun 2012 17:45:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frank Swiderski <fes@google.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
References: <1340742778-11282-1-git-send-email-fes@google.com> <4FEA1E2E.4020806@redhat.com> <CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com>
In-Reply-To: <CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 05:31 PM, Frank Swiderski wrote:
> On Tue, Jun 26, 2012 at 1:40 PM, Rik van Riel<riel@redhat.com>  wrote:

>> The code looks good to me, my only worry is the
>> code duplication. We now have 5 balloon drivers,
>> for 4 hypervisors, all implementing everything
>> from scratch...
>
> Do you have any recommendations on this?  I could (I think reasonably
> so) modify the existing virtio_balloon.c and have it change behavior
> based on a feature bit or other configuration.  I'm not sure that
> really addresses the root of what you're pointing out--it's still
> adding a different implementation, but doing so as an extension of an
> existing one.

Ideally, I believe we would have two balloon
top parts in a guest (one classical balloon,
one on the LRU), and four bottom parts (kvm,
xen, vmware & s390).

That way the virt specific bits of a balloon
driver would be essentially a ->balloon_page
and ->release_page callback for pages, as well
as methods to communicate with the host.

All the management of pages, including stuff
like putting them on the LRU, or isolating
them for migration, would be done with the
same common code, regardless of what virt
software we are running on.

Of course, that is a substantial amount of
work and I feel it would be unreasonable to
block anyone's code on that kind of thing
(especially considering that your code is good),
but I do believe the explosion of balloon
code is a little worrying.

