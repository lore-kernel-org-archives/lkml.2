Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723Ab2LGQWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:22:04 -0500
Received: from rmail.zodiacaerospace.com ([195.101.36.5]:33179 "EHLO
	rmail.zodiacaerospace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422698Ab2LGQWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:22:02 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 11:22:01 EST
X-Disclaimed: 1
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: 
References: 
Subject: alc262 streams synchronization
From: Jonathan.Klee@zodiacaerospace.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.se, david.henningsson@canonical.com
Message-ID: <OF16C35AAD.E6009EAC-ONC1257ACD.005802AE-C1257ACD.00580416@zodiacaerospace.com>
Date: Fri, 7 Dec 2012 17:01:22 +0100
X-Mailer: Lotus Domino Web Server Release 8.5.2FP2 March 22, 2011
X-MIMETrack: Serialize by HTTP Server on SISS-DOM1/GROUP/ZODIAC(Release 8.5.2FP2|March
 22, 2011) at 07/12/2012 17:01:22,
	Serialize complete at 07/12/2012 17:01:22,
	Itemize by HTTP Server on SISS-DOM1/GROUP/ZODIAC(Release 8.5.2FP2|March 22, 2011) at
 07/12/2012 17:01:22,
	Serialize by Router on ZODIAC_EUROPE_1/ZODIAC(Release 8.5.2FP2|Mar 22, 2011) at
 12/07/2012 16:59:23,
	Serialize complete at 12/07/2012 16:59:23
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-12-06_08:2012-12-06,2012-12-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1211240000 definitions=main-1212070123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have faced the following issue with alc262 codec on kernel 3.2.34 :

Trying to play a file through vlc (libvlc/emotion), I did not have any sound on the speakers. Having a look at my kernel logs, I have noticed 2 calls to snd_hda_codec_setup_stream() separated by a call to __snd_hda_codec_cleanup_stream().

Nevertheless, adding some debug prints, I have noticed only one call to snd_hda_codec_write() in snd_hda_codec_setup_stream() to set the stream id. It seems like the stream id of the codec was not synchronized with the flag p->active the kernel maintains for the codec.

Setting the no_sticky_stream field in patch_alc262.c solved the issue. What about setting that field ? Am I the only one who faced that issue ?


--- a/sound/pci/hda/patch_realtek.c     2012-12-04 12:46:22.000000000 +0100
+++ b/sound/pci/hda/patch_realtek.c     2012-12-04 13:52:37.000000000 +0100
@@ -4490,6 +4490,8 @@
        if (spec == NULL)
                return -ENOMEM;

+       codec->no_sticky_stream=1;
+       printk(KERN_INFO "hda_codec: no sticky stream set\n");
        codec->spec = spec;

   
--
Jonathan Klee 

Embedded Software Engineer
Zodiac IFE
Tel: +33 1 61 34 11 71
http://www.zodiacaerospace.com
