Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030590Ab2AFVKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:10:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54389 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030511Ab2AFVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:10:51 -0500
Date: Fri, 6 Jan 2012 21:10:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Frank Mandarino <fmandarino@endrelia.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the
	driver model
Message-ID: <20120106211027.GA17842@n2100.arm.linux.org.uk>
References: <20120106194052.GA7781@kroah.com> <20120106201458.GF2893@opensource.wolfsonmicro.com> <20120106205036.GB13857@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106205036.GB13857@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 08:50:36PM +0000, Russell King - ARM Linux wrote:
> I also disagree with your statement - I think it's quite simple to fix:
> 
> 1. Change to using a flag to indicate whether the struct device is
>    registered rather than ac97->dev.bus.

Looking at this deeper, you already have such a flag.  It's called
codec->ac97_registered:

                ret = soc_ac97_dev_register(rtd->codec);
                if (ret < 0) {
                        printk(KERN_ERR "asoc: AC97 device register failed\n");
                        return ret;
                }

                rtd->codec->ac97_registered = 1;

static void soc_unregister_ac97_dai_link(struct snd_soc_codec *codec)
{
        if (codec->ac97_registered) {
                soc_ac97_dev_unregister(codec);
                codec->ac97_registered = 0;
        }
}

and soc_ac97_dev_{un,}register() do this:

static int soc_ac97_dev_unregister(struct snd_soc_codec *codec)
{
        if (codec->ac97->dev.bus)
                device_unregister(&codec->ac97->dev);
        return 0;
}

static int soc_ac97_dev_register(struct snd_soc_codec *codec)
{
        int err;

        codec->ac97->dev.bus = &ac97_bus_type;
...
        err = device_register(&codec->ac97->dev);
        if (err < 0) {
...
                codec->ac97->dev.bus = NULL;
                return err;
        }
        return 0;
}


So, dev.bus is really duplicating what ac97_registered is doing and nothing
more, and I'd suggest that the very first patch cleaning up this buggy code
is to get rid of this duplication:

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a25fa63..961f980 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -452,8 +452,7 @@ static inline void soc_cleanup_card_debugfs(struct snd_soc_card *card)
 /* unregister ac97 codec */
 static int soc_ac97_dev_unregister(struct snd_soc_codec *codec)
 {
-	if (codec->ac97->dev.bus)
-		device_unregister(&codec->ac97->dev);
+	device_unregister(&codec->ac97->dev);
 	return 0;
 }
 
@@ -474,7 +473,6 @@ static int soc_ac97_dev_register(struct snd_soc_codec *codec)
 	err = device_register(&codec->ac97->dev);
 	if (err < 0) {
 		snd_printk(KERN_ERR "Can't register ac97 bus\n");
-		codec->ac97->dev.bus = NULL;
 		return err;
 	}
 	return 0;

Second patch would be to make soc_ac97_dev_unregister return type void -
it's pointless to have a function which always returns 0 and its return
value is never checked at its solitary call site.

Overall, it should look something like this (untested):

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a25fa63..090b89e 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -448,33 +448,34 @@ static inline void soc_cleanup_card_debugfs(struct snd_soc_card *card)
 }
 #endif
 
+/* stop no dev release warning */
+static void soc_ac97_device_release(struct device *dev)
+{
+	struct snd_ac97 *ac97 = container_of(dev, snd_ac97, dev);
+
+	kfree(ac97);
+}
+
 #ifdef CONFIG_SND_SOC_AC97_BUS
 /* unregister ac97 codec */
 static int soc_ac97_dev_unregister(struct snd_soc_codec *codec)
 {
-	if (codec->ac97->dev.bus)
-		device_unregister(&codec->ac97->dev);
+	device_del(&codec->ac97->dev);
 	return 0;
 }
 
-/* stop no dev release warning */
-static void soc_ac97_device_release(struct device *dev){}
-
 /* register ac97 codec to bus */
 static int soc_ac97_dev_register(struct snd_soc_codec *codec)
 {
 	int err;
 
 	codec->ac97->dev.bus = &ac97_bus_type;
-	codec->ac97->dev.parent = codec->card->dev;
-	codec->ac97->dev.release = soc_ac97_device_release;
 
 	dev_set_name(&codec->ac97->dev, "%d-%d:%s",
 		     codec->card->snd_card->number, 0, codec->name);
-	err = device_register(&codec->ac97->dev);
+	err = device_add(&codec->ac97->dev);
 	if (err < 0) {
 		snd_printk(KERN_ERR "Can't register ac97 bus\n");
-		codec->ac97->dev.bus = NULL;
 		return err;
 	}
 	return 0;
@@ -1748,9 +1749,13 @@ int snd_soc_new_ac97_codec(struct snd_soc_codec *codec,
 		return -ENOMEM;
 	}
 
+	device_initialize(&codec->ac97->dev);
+	codec->ac97->dev.parent = codec->card->dev;
+	codec->ac97->dev.release = soc_ac97_device_release;
+
 	codec->ac97->bus = kzalloc(sizeof(struct snd_ac97_bus), GFP_KERNEL);
 	if (codec->ac97->bus == NULL) {
-		kfree(codec->ac97);
+		device_put(&codec->ac97->dev);
 		codec->ac97 = NULL;
 		mutex_unlock(&codec->mutex);
 		return -ENOMEM;
@@ -1783,7 +1788,7 @@ void snd_soc_free_ac97_codec(struct snd_soc_codec *codec)
 	soc_unregister_ac97_dai_link(codec);
 #endif
 	kfree(codec->ac97->bus);
-	kfree(codec->ac97);
+	device_put(&codec->ac97->dev);
 	codec->ac97 = NULL;
 	codec->ac97_created = 0;
 	mutex_unlock(&codec->mutex);

