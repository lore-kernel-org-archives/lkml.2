Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1HSKXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab1HSKXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:23:02 -0400
Message-ID: <4E4E395B.7070106@redhat.com>
Date: Fri, 19 Aug 2011 12:22:19 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>, containers@lists.osdl.org
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org>
In-Reply-To: <m17h69sr03.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/19/2011 11:13 AM, Eric W. Biederman wrote:
> Milan Broz <mbroz@redhat.com> writes:
> 
> I think the proper fix is to remove the error return from
> kobject_uevent_env and kobject_uevent, and make it harder to get calling
> of this function wrong.  Possibly in conjunction with that tag all of
> the memory allocations of kobject_uevent_env with GFP_NOFAIL or
> something so the memory allocator knows that this path is totally
> not able to deal with failure.
> 
> Is kobject_uevent_env anything except an asynchronous best effort
> notification to user-space that a device has come or gone?

Unfortunately it is for device-mapper. libdevmapper
depends on information that uevent was sent because udev rules uses
semaphore to inform that some action was taken.
So if dm-ioctl returns flag that uevent was not sent, it fallback
to different error path (otherwise it waits for completion forever).
(TBH I am more and more convinced this was not quite clever concept.)

But the whole concept "send event to the list of namespaces, maybe someone listen"
seems also not quite clever to me :-)

How much time consuming is that? If you create thousand(s) of cloned namespaces,
how it will perform with uevent notification performance?
(IOW first event is sent through netlink and 999+ reports failure... strange.)

Milan
