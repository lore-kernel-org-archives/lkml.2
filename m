Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0HDKZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:25:30 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:38451 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756253Ab0HDKZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:25:29 -0400
Date: Wed, 4 Aug 2010 12:25:26 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804102526.GB13766@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org> <20100804091317.GA27779@isilmar-3.linta.de> <20100804092122.GA2998@infradead.org> <20100804073546.GA7494@comet.dominikbrodowski.net> <201008041116.09822@zmi.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804092122.GA2998@infradead.org> <201008041116.09822@zmi.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

many thanks for your feedback. It seems the crypto step is the culprit:

Reading 1.1 GB with dd, iflag=direct, bs=8k:

/dev/sd*                35.3 MB/s       ( 90 %)
/dev/md*                39.1 MB/s       (100 %)
/dev/mapper/md*_crypt    3.9 MB/s       ( 10 %)
/dev/mapper/vg1-*        3.9 MB/s       ( 10 %)

The "good" news: it also happens on my notebook, even though it has a
different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
more than happy to test out different kernel versions, patches etc.

/dev/sd*                17.7 MB/s       (100 %)
/dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
/dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

On a different system, a friend of mine reported (with 2.6.33):

/dev/sd*		51.9 MB/s	(100 %)
dm-crypt		32.9 MB/s	( 64 %)

This shows that the speed drop when using dmcrypt is not always a factor of
5 to 10... Btw, it occurs both with aes-lrw-benbi and aes-cbc-essiv:sha256 ,
and (on my notebook) the CPU is mostly idling or waiting. 

Best,
	Dominik

PS: Bonnie output:

Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ABCABCABCABCABC 16G           60186   4 24796   4           53386   5 281.1   1
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  3176  16 +++++ +++  4641  28  5501  20 +++++ +++  2286   9
ABCABCABCABCABCABC,16G,,,60186,4,24796,4,,,53386,5,281.1,1,16,3176,16,+++++,+++,4641,28,5501,20,+++++,+++,2286,9

