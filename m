Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2AQKDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:03:43 -0500
Received: from twin.jikos.cz ([89.185.236.188]:55422 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2AQKDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:03:42 -0500
X-Greylist: delayed 3324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 05:03:42 EST
Date: Tue, 17 Jan 2012 10:07:46 +0100
From: David Sterba <dave@jikos.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Message-ID: <20120117090746.GD7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:28:47PM -0800, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

Recently the LZ4 method showed up on the real-time compression scene

http://fastcompression.blogspot.com/p/lz4.html (homepage)
http://code.google.com/p/lz4/ (source repo)

it has comparable performance and compression ratio to snappy. Quoting
from the source repo main page:

Name            Ratio   C.speed D.speed
LZ4 (r41)       2.08    319     1070
LZO 2.05 1x_1   2.07    318      466
Snappy 1.0.4    2.02    242      683

My own benchmarking confirms that lz4 is has a bit faster decompression,
but what is a big difference from snappy is it's memory consumption for
compression:
* 32kb for unbounded chunksize
* 16kb for chunksize < 64k (a tuned compression)

No additional memory is needed for decompression in both snappy and lz4.
With a minor tweak and chunksize < 4G the context size could be reduced
to 16k as well.

There is also LZ4HC, "high compression" mode, which maintains same
binary format, but the compression ratio is better.

http://code.google.com/p/lz4hc/

Usecase:
There could be the fast version used transparently and the -hc version
could be allowed for the 'fi defrag' command in order to recompress
selected files.

LZ4 is written in C and it's BSD, LZ4HC is L-GPL. There is some space
for improvements in the code, but as it's good already as it stands now.


david
