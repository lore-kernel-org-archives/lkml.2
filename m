Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2LEIBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:01:07 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39075 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LEIBD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 5 Dec 2012 03:01:03 -0500
Message-Id: <50BF0D4902000078000AE0D0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 05 Dec 2012 08:00:57 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: do not leak mode property
References: <1354563168-6609-1-git-send-email-olaf@aepfle.de>
 <50BDDEBF02000078000ADAAC@nat28.tlf.novell.com>
 <20121204182151.GA25878@aepfle.de>
In-Reply-To: <20121204182151.GA25878@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.12.12 at 19:21, Olaf Hering <olaf@aepfle.de> wrote:
> On Tue, Dec 04, Jan Beulich wrote:
> 
>> This looks necessary but insufficient - there's nothing really
>> preventing backend_changed() from being called more than once
>> for a given device (is simply the handler of xenbus watch). Hence
>> I think either that function needs to be guarded against multiple
>> execution (e.g. by removing the watch from that function itself,
>> if that's permitted by xenbus), or to properly deal with the
>> effects this has (including but probably not limited to the leaking
>> of be->mode).
> 
> If another watch does really trigger after the kfree(be) in
> xen_blkbk_remove(), wouldnt backend_changed access stale memory?
> So if that can really happen in practice, shouldnt the backend_watch be
> a separate allocation instead being contained within backend_info?
> 
> Looking at unregister_xenbus_watch, it clears removes the watch from the
> list, so that process_msg will not see it anymore.

That's not the scenario I was talking about: I'm concerned about
multiple calls to backend_changed() to similarly leak "mode" (and
possibly cause other bad stuff to happen) while the device is still
alive - after all it overwrites "mode" without checking what's in
there.

Jan

