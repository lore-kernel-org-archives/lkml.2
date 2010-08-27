Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0H0Jst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:48:49 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50999 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0H0Jsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:48:43 -0400
Message-ID: <4C7789BE.1060609@ct.jp.nec.com>
Date: Fri, 27 Aug 2010 18:47:42 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, tytso@mit.edu,
        linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp,
        linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com,
        Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com,
        dm-devel@redhat.com
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org> <20100823141733.GA21158@redhat.com> <4C739DE9.5070803@ct.jp.nec.com> <4C73FA8F.5080800@kernel.org> <4C74CD95.1000208@ct.jp.nec.com> <20100825152831.GA8509@redhat.com>
In-Reply-To: <20100825152831.GA8509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 08/26/2010 12:28 AM +0900, Mike Snitzer wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>> Anyway, as you said, the flush error handling of dm-mpath is already
>> broken if data loss really happens on any storage used by dm-mpath.
>> Although it's a serious issue and quick fix is required, I think
>> you may leave the old behavior in your patch-set, since it's
>> a separate issue.
> 
> I'm not seeing where anything is broken with current mpath.  If a
> multipathed LUN is WCE=1 then it should be fair to assume the cache is
> mirrored or shared across ports.  Therefore retrying the SYNCHRONIZE
> CACHE is needed.
> 
> Do we still have fear that SYNCHRONIZE CACHE can silently drop data?
> Seems unlikely especially given what Tejun shared from SBC.

Do we have any proof to wipe that fear?

If retrying on flush failure is safe on all storages used with multipath
(e.g. SCSI, CCISS, DASD, etc), then current dm-mpath should be fine in
the real world.
But I'm afraid if there is a storage where something like below can happen:
    - a flush command is returned as error to mpath because a part of
      cache has physically broken at the time or so, then that part of
      data loses and the size of the cache is shrunk by the storage.
    - mpath retries the flush command using other path.
    - the flush command is returned as success to mpath.
    - mpath passes the result, success, to upper layer, but some of
      the data already lost.

Thanks,
Kiyoshi Ueda
